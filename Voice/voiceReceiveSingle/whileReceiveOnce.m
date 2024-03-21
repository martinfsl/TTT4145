run setupModulesV2.m

close all

stop = 0;
while ~stop
    tic
    [rxSignal, AAvalidData, AAOverflow] = rx();
    % rxSignal = allRxSignals(:, 1);
    
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
    
    % Preamble detector
    [idx, detmet] = detector(rxSignalFine);
    
    if ~isempty(idx)
        if detmet(idx(1)) > 10
            plot(detmet);
            frameStart = idx(1) - length(preamble) + 2;
            
            receivedPreamble = rxSignalFine(...
                        frameStart:(frameStart + length(preamble) - 1));
            rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, receivedPreamble);
    
            [rxFrameSynced, rxMessage, rxHeader] = ...
                frameSyncSingle(rxSignalPhaseCorr, frameStart, preambleMod, frameSize, header);

            decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
            decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");

            stop = 1;
        end
    end

    toc
end
