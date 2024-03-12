% allMessages = []; allHeaders = [];
corrVal = 0;

amountReceived = ;

while length(allHeaders) < amountReceived
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

    if corrVal > 30
        rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, frameStart, prevRxSignal);

        % Frame Synchronization
        [rxFrameSynced, rxMessage, rxHeader] = ...
            frameSync(rxSignalPhaseCorr, frameStart, preambleMod, frameSize, header);
        
        % prevRxSignal = rxSignal;
        decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
        decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");

        h = 16*mode(decodedHeader(1:3)) + ...
             4*mode(decodedHeader(4:6)) + ...
             1*mode(decodedHeader(7:9));
        
        if (~ismember(h, allHeaders) && ...
             ismember(h, possibleHeaders))
            plot(lags, abs(corr));
            drawnow;
            disp("New message found!");
            allMessages = [allMessages, decodedMessage];
            allHeaders = [allHeaders; h];
        end
    end
    toc
end