allHeaders = []; 
allHeadersAcrossBulks = [];

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

global deviceWriter
deviceWriter = audioDeviceWriter('SampleRate', 16000, 'BufferSize', bufferSize*frameSize/4);

playbackPeriod = deviceWriter.BufferSize/deviceWriter.SampleRate - 0.003;
playbackTimer = timer('ExecutionMode', 'fixedSpacing', ...
                      'Period', playbackPeriod, ...
                      'TimerFcn', @(~,~)playNextAudioChunk());
start(playbackTimer);

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

    % CFC
    rxSignalCoarse = coarseFreqComp(rxFiltered);
    
    % Timing Synchronization
    rxTimingSync = symbolSync(rxSignalCoarse);
    
    % FFC
    rxSignalFine = fineFreqComp(rxTimingSync);
    
    % Preamble detector
    [idx, ~] = detector(rxSignalFine);

    % This is to avoid getting indices during start up where
    % the correlation is 'mushed'   
    if ~isempty(idx)
        idx = selectValidIndices(idx, frameSize);
    end

    if length(idx) > 1

        % Correcting the phase using the previous estimate
        rxSignalFine = rxSignalFine .* exp(-1i * phase);

        foundPreamble = rxSignalFine(idx(2)-length(preamble)+1:idx(2));

        % Correcting the phase using a new estimate
        [rxSignalPhaseCorr, phase] = phaseCorrection(rxSignalFine, preambleMod, ...
            foundPreamble);

        % Extracting the headers and messages found
        [foundHeaders, foundMessages] = frameSyncSingle(...
            rxSignalPhaseCorr, idx, frameSize, length(bulk_header)+length(header), M);

        for f = 1:size(foundHeaders, 2)
            decodedHeader = foundHeaders(:, f);
            decodedMessage = foundMessages(:, f);
            
            % h_bulk = 4*mode(decodedHeader(1:3)) + ...
            %            mode(decodedHeader(4:6));
            % 
            % h = 16*mode(decodedHeader(1:3)) + ...
            %      4*mode(decodedHeader(4:6)) + ...
            %      1*mode(decodedHeader(7:9));

            % Looking at the code above:
            %   Used the decodedHeader to also extract the bulk header
            %   This does not make sense!

            h_bulk = 4*mode(decodedHeader(1:3)) + ...
                       mode(decodedHeader(4:6));

            h = 16*mode(decodedHeader(7:9)) + ...
                 4*mode(decodedHeader(10:12)) + ...
                 1*mode(decodedHeader(13:15));
            
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

                allHeaders = [allHeaders; h];
                allHeadersAcrossBulks = [allHeadersAcrossBulks; [h, h_bulk]];
            end

            isUnique = 0;

            if length(allHeaders) >= bulkSize
                invalidBulkHeaders = [invalidBulkHeaders, h_bulk];
                allHeaders = [];
            end
        end
    end

    overlapBuffer = rxSignal(end-overlapSize+1:end);

    toc
end

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