allHeaders = []; 

allHeaders_sorted = [];

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
global bufferLowerLimit
bufferLowerLimit = 10;

% deviceWriter = audioDeviceWriter('SampleRate', 16000, 'BufferSize', 2*frameSize/4);
% deviceWriter = audioDeviceWriter('SampleRate', 44100, 'BufferSize', frameSize/4);

global deviceWriter
% deviceWriter = audioDeviceWriter('SampleRate', 44100, 'BufferSize', bufferSize*frameSize/4);
% deviceWriter = audioDeviceWriter('SampleRate', 16000, 'BufferSize', bufferSize*frameSize/4);
% deviceWriter = audioDeviceWriter('SampleRate', 24000, 'BufferSize', bufferSize*frameSize/4);
deviceWriter = audioDeviceWriter('SampleRate', 11025, 'BufferSize', bufferSize*frameSize/4);

playbackPeriod = deviceWriter.BufferSize/deviceWriter.SampleRate - 0.007;
playbackTimer = timer('ExecutionMode', 'fixedSpacing', ...
                      'Period', playbackPeriod, ...
                      'TimerFcn', @(~,~)playNextAudioChunk());
start(playbackTimer);

% audioSize = 29000/4;
% setup(deviceWriter, zeros(frameSize/4, 1));

phase = 0;

backwardView = 10;

amountReceived = 300;
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

        [foundHeaders, foundMessages] = frameSyncSingle(...
            rxSignalPhaseCorr, idx, frameSize, length(header), M);

        % % Sorting
        % [foundHeaders, sortIdx] = sort(foundHeaders, 'ascend');
        % foundMessages = foundMessages(sortIdx);

        found_h = [];
        found_messages = [];

        for f = 1:size(foundHeaders, 2)
            decodedHeader = foundHeaders(:, f);
            decodedMessage = foundMessages(:, f);

            h = 16*mode(decodedHeader(1:3)) + ...
                 4*mode(decodedHeader(4:6)) + ...
                 1*mode(decodedHeader(7:9));
            
            if (length(allHeaders) > backwardView)
                if (~ismember(h, allHeaders(end-backwardView:end)) && ...
                     ismember(h, possibleHeaders))
                    isUnique = 1;
                end
            elseif (length(allHeaders) <= backwardView)
                if (~ismember(h, allHeaders) && ...
                     ismember(h, possibleHeaders))
                    isUnique = 1;
                end
            end
    
            if isUnique
                fprintf("%s %i \n", "New message found - header: ", h+1);
    
                % buffer = [buffer, decodedMessage];
                % disp(size(buffer, 2));

                allHeaders = [allHeaders; h];

                found_h = [found_h; h];
                found_messages = [found_messages, decodedMessage];
            end

            isUnique = 0;
            
        end

        if ~isempty(found_h)
            [sorted_h, sortIdx] = sort(found_h, 'ascend');
            allHeaders_sorted = [allHeaders_sorted; sorted_h];
            sorted_messages = found_messages(:, sortIdx);

            buffer = [buffer, sorted_messages];
            disp(size(buffer, 2));
        end
    end

    overlapBuffer = rxSignal(end-overlapSize+1:end);

    toc
end

listOfTimers = timerfindall

while ~isempty(listOfTimers)
    if size(buffer, 2) < bufferLowerLimit
        % Stopping the timer
        listOfTimers = timerfindall;
        if ~isempty(listOfTimers)
            delete(listOfTimers(:));
        end
    end
end