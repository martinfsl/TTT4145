allHeadersAcrossBulks = [];

corrVal = 0;

overlapSize = sps*(length(bitStream)) + span + 100;
overlapBuffer = zeros(overlapSize, 1);

phase = 0;

% Backward View
% bwView = 2;
bwView = 0;

stop = 0;
while ~stop
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

        middleIndex = ceil(length(idx)/2);
        foundPreamble = rxSignalFine(idx(middleIndex)-length(preamble)+1:...
                                     idx(middleIndex));
        % foundPreamble = rxSignalFine(idx(2)-length(preamble)+1:idx(2));

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

            h = 4*mode(decodedHeader(7:9)) + ...
                1*mode(decodedHeader(10:12));

            if checkIfUnique(...
                    allHeadersAcrossBulks, h, bwView, possibleHeaders)

                fprintf("%s %s %i %s %i \n", ...
                    "New message found", ...
                    "header: ", h, ...
                    "bulk: ", h_bulk);

                allHeadersAcrossBulks = [allHeadersAcrossBulks; ...
                        [h, h_bulk, "message:", decodedMessage']];

                stop = 1;
            end
        end
    end

    overlapBuffer = rxSignal(end-overlapSize+1:end);
end

% scatterplot(rxSignal);
% scatterplot(rxFiltered);
% scatterplot(rxSignalCoarse);
% scatterplot(rxTimingSync);
% scatterplot(rxSignalFine);
% scatterplot(rxSignalPhaseCorr);
% scatterplot(foundPreamble);
% 
% eyediagram(rxSignalCoarse, 3);
% eyediagram(rxTimingSync, 3);

% eyediagram(rxSignalCoarse(20000:20500), 2);
% eyediagram(rxTimingSync(4000:4500), 2);
% eyediagram(rxSignalFine(4000:4500), 2);