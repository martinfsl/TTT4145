allHeaders = []; 
allBulks = [];

allMessages = [];

allDetmet = [];

corrVal = 0;
isUnique = 0;

overlapSize = sps*(length(bitStream)) + span + 40;
overlapBuffer = zeros(overlapSize, 1);

global buffer
buffer = [];
global bufferSize
bufferSize = 5;

h_bulk = 0; % Initialization
invalidBulkHeaders = [];
bulkSize = 50;

% deviceWriter = audioDeviceWriter('SampleRate', 16000, 'BufferSize', 2*frameSize/4);
% deviceWriter = audioDeviceWriter('SampleRate', 44100, 'BufferSize', frameSize/4);

global deviceWriter
% deviceWriter = audioDeviceWriter('SampleRate', 44100, 'BufferSize', bufferSize*frameSize/4);
% deviceWriter = audioDeviceWriter('SampleRate', 16000, 'BufferSize', bufferSize*frameSize/4);
% deviceWriter = audioDeviceWriter('SampleRate', 24000, 'BufferSize', bufferSize*frameSize/4);
% deviceWriter = audioDeviceWriter('SampleRate', 11025, 'BufferSize', bufferSize*frameSize/4);
deviceWriter = audioDeviceWriter('SampleRate', 16000, 'BufferSize', bufferSize*frameSize/4);

playbackPeriod = deviceWriter.BufferSize/deviceWriter.SampleRate - 0.003;
playbackTimer = timer('ExecutionMode', 'fixedSpacing', ...
                      'Period', playbackPeriod, ...
                      'TimerFcn', @(~,~)playNextAudioChunk());
start(playbackTimer);

% audioSize = 29000/4;
% setup(deviceWriter, zeros(frameSize/4, 1));

phase = 0;

backwardView = 10;

% amountReceived = 200;
% amountReceived = 300;
amountReceived = 100;
while length(allHeaders) < amountReceived
    tic
    [rxSignal, AAvalidData, AAOverflow] = rx();

    rxSignal = [overlapBuffer; rxSignal];

    release(coarseFreqComp);
    release(symbolSync);
    release(fineFreqComp);
    
    % Matched Filtering
    rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
    % rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

    % CFC
    rxSignalCoarse = coarseFreqComp(rxFiltered);
    
    % Timing Synchronization
    rxTimingSync = symbolSync(rxSignalCoarse);
    
    % FFC
    rxSignalFine = fineFreqComp(rxTimingSync);
    
    [idx, ~] = detector(rxSignalFine);

    % [idx, detmet] = detector(rxSignalFine);

    % plot(detmet);
    % drawnow;

    % s = struct; s.detmet = detmet;
    % allDetmet = [allDetmet, s];
    
    % This is to avoid getting indices during start up where
    % the correlation is 'mushed'   
    if ~isempty(idx)
        idx = selectValidIndices(idx, frameSize);
    end

    if length(idx) > 1

        rxSignalFine = rxSignalFine .* exp(-1i * phase);

        foundPreamble = rxSignalFine(idx(2)-length(preamble)+1:idx(2));

        [rxSignalPhaseCorr, phase] = phaseCorrection(rxSignalFine, preambleMod, ...
            foundPreamble);

        [foundBulkHeaders, foundHeaders, foundMessages] = frameSyncSingle(...
            rxSignalPhaseCorr, idx, frameSize, length(bulk_header), length(header), M);

        % [foundHeaders, sortIdx] = sort(foundHeaders, 'ascend');
        % 
        % foundMessages = foundMessages(sortIdx);

        for f = 1:size(foundHeaders, 2)
            decodedBulkHeader = foundHeaders(:, f);
            decodedHeader = foundHeaders(:, f);
            decodedMessage = foundMessages(:, f);
            
            h_bulk = 4*mode(decodedHeader(1:3)) + ...
                       mode(decodedHeader(4:6));

            h = 16*mode(decodedHeader(1:3)) + ...
                 4*mode(decodedHeader(4:6)) + ...
                 1*mode(decodedHeader(7:9));
            
            if (length(allHeaders) > backwardView)
                if (~ismember(h, allHeaders(end-backwardView:end)) && ...
                     ismember(h, possibleHeaders) && ...
                    ~ismember(h_bulk, invalidBulkHeaders))

                    isUnique = 1;
                end
            elseif (length(allHeaders) <= backwardView)
                if (~ismember(h, allHeaders) && ...
                     ismember(h, possibleHeaders) && ...
                    ~ismember(h_bulk, invalidBulkHeaders))

                    isUnique = 1;
                end
            end
    
            if isUnique
                fprintf("%s %i \n", "New message found - header: ", h+1);
    
                % error = min(symerr(decodedMessage, trueMessages));
                % fprintf("%s %i %s %i \n", "The error was: ", error, " in header ", h+1);
    
                buffer = [buffer, decodedMessage];
                disp(size(buffer, 2));

                % deviceWriter(reconstructVoiceSignal(decodedMessage));

                % sound(reconstructVoiceSignal(decodedMessage), 44100);
    
                allHeaders = [allHeaders; h];

                % allMessages = [allMessages, decodedMessage];
            end

            isUnique = 0;
        end
    end

    overlapBuffer = rxSignal(end-overlapSize+1:end);

    % if size(buffer, 2) > bufferSize
    %     disp("Playing sound");
    % 
    %     deviceWriter(reconstructVoiceSignal([buffer(:, 1); buffer(:, 2)]));
    % 
    %     % recVoice = reconstructVoiceSignal([buffer(:, 1); buffer(:, 2)]);
    %     % sound(recVoice, 16000);
    % 
    %     buffer = buffer(:, 2:end);
    % end

    toc

    if length(allHeaders) >= bulkSize
        invalidBulkHeaders = [invalidBulkHeaders, h_bulk];
        allHeaders = [];
    end
end

% audioToPlay = allMessages(:, 1:130);
% sound(reconstructVoiceSignal(audioToPlay(:)), 44100);

% audioToPlay = allMessages(:, 1:10);
% deviceWriter(reconstructVoiceSignal(audioToPlay(:)));

listOfTimers = timerfindall

while ~isempty(listOfTimers)
    if size(buffer, 2) < bufferSize
        % Stopping the timer
        listOfTimers = timerfindall;
        if ~isempty(listOfTimers)
            delete(listOfTimers(:));
        end
    end
end