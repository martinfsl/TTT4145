% run setupModules.m
close all

detmat = [0];
    
while max(detmat) < detector.Threshold
    tic
    [rxSignal, AAvalidData, AAOverflow] = rx();
    % rxSignal = [rxSignal; overlapBuffer];
    
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
    
    if length(idx) > 1
        
        foundPreamble = rxSignalFine(idx(2)-length(preamble)+1:idx(2));
        
        [rxSignalPhaseCorr, phase] = phaseCorrection(rxSignalFine, preambleMod, ...
            foundPreamble);
        
        [foundHeaders, foundMessages] = frameSyncSingle(...
            rxSignalPhaseCorr, idx, frameSize, length(header), M);
        
        for f = 1:size(foundHeaders, 2)
            decodedHeader = foundHeaders(:, f);
            decodedMessage = foundMessages(:, f);
        end
    end
    
    toc
end

plot(detmat)