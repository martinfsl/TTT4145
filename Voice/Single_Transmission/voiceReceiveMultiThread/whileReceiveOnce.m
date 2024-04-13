% run setupModules.m
close all

detmat = zeros(27025, 1);
    
% while max(detmat) < detector.Threshold
while 1
    tic
    [rxSignal, AAvalidData, AAOverflow] = rx();
    % rxSignal = [rxSignal; overlapBuffer];

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
    
    % [idx, ~] = detector(rxSignalFine);
    [idx, detmat] = detector(rxSignalFine);
    if ~isempty(idx)
        idx = selectValidIndices(idx, frameSize);
    end

    plot(detmat);
    drawnow;
    
    if length(idx) > 1
        
        foundPreamble = rxSignalFine(idx(2)-length(preamble)+1:idx(2));
        
        [rxSignalPhaseCorr, phase] = phaseCorrection(rxSignalFine, preambleMod, ...
            foundPreamble);
        
        [foundHeaders, foundMessages] = frameSyncSingle(...
            rxSignalPhaseCorr, idx, frameSize, length(header), M);
        
        headers = [];
        for f = 1:size(foundHeaders, 2)
            decodedHeader = foundHeaders(:, f);
            decodedMessage = foundMessages(:, f);

            h = 16*mode(decodedHeader(1:3)) + ...
                 4*mode(decodedHeader(4:6)) + ...
                 1*mode(decodedHeader(7:9));
            headers = [headers; h];
        end
        disp(headers);
    end
    
    toc
end