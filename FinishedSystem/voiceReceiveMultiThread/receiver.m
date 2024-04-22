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
% bufferSize = 10;
% bufferSize = 3;
bufferSize = 30;

h_bulk = 0; % Initialization
invalidBulkHeaders = [];
bulkSize = 50;
% bulkSize = 20;
% bulkSize = 18;
% bulkSize = 15;

global deviceWriter
deviceWriter = audioDeviceWriter('SampleRate', 11200, 'BufferSize', bufferSize*frameSize/4);

playbackPeriod = deviceWriter.BufferSize/deviceWriter.SampleRate - 0.003;
playbackTimer = timer('ExecutionMode', 'fixedSpacing', ...
                      'Period', playbackPeriod, ...
                      'TimerFcn', @(~,~)playNextAudioChunk());
start(playbackTimer);

phase = 0;

% Backward View
bwView = 10;
bulk_bwView  = 5;

while true

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
            
            h_bulk = 4*mode(decodedHeader(1:3)) + ...
                       mode(decodedHeader(4:6));

            h = 16*mode(decodedHeader(7:9)) + ...
                 4*mode(decodedHeader(10:12)) + ...
                 1*mode(decodedHeader(13:15));
            
            % if isUnique
            if checkIfUnique(...
                    allHeaders, h, bwView, possibleHeaders, ...
                    invalidBulkHeaders, h_bulk, bulk_bwView)

                fprintf("%s %s %i %s %i \n", ...
                    "New message found", ...
                    "header: ", h, ...
                    "bulk: ", h_bulk);
    
                % error = min(symerr(decodedMessage, trueMessages));
                % fprintf("%s %i %s %i \n", "The error was: ", error, " in header ", h+1);
    
                buffer = [buffer, decodedMessage];
                disp(size(buffer, 2));

                allHeaders = [allHeaders; h];
                allHeadersAcrossBulks = [allHeadersAcrossBulks; [h, h_bulk]];
            end

            isUnique = 0;

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