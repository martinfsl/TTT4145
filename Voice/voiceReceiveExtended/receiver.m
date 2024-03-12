corrVal = 0;

while 1
    tic

    [rxSignal, AAvalidData, AAOverflow] = rx();
    
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
    
    % Phase Correction
    [frameStart, corrVal, corr, lags]= estFrameStart(rxSignalFine, preambleMod, bitStream);
    toc

    if corrVal > 50
        disp("Message found!");

        plot(lags, abs(corr));
        
        rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, frameStart, prevRxSignal);
        
        % Frame Synchronization
        [rxFrameSynced, rxMessage, rxPreamble, rxHeader] = ...
            frameSync(rxSignalPhaseCorr, frameStart, preambleMod, frameSize, header);
        
        prevRxSignal = rxSignal;
        
        decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
        decodedPreamble = pskdemod(rxPreamble, M, pi/M, "gray");
        decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");
        
        error = symerr(decodedMessage, trueMessage)
        
        scatterplot(rxMessage);

        break
    end

    toc

end
