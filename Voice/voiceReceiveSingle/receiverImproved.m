close all;

allMessages = []; allHeaders = []; 
allRxSignals = [];

corrVal = 0;
phase = 0;

    while corrVal < 15
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
        [frameStart, isOverflow, overflowSize, corrVal, isValid, corr, lags] = ...
            estFrameStart(rxSignalFine, preambleMod, bitStream);
    
        plot(lags, abs(corr));
        drawnow;
    end
    
    rxSignalFine = rxSignalFine .* exp(-1i * phase);
    
    [rxSignalPhaseCorr, phase] = phaseCorrection(rxSignalFine, preambleMod, ...
                                        frameStart, prevRxSignal);
    
    % Frame Synchronization
    [rxMessage, rxHeader] = ...
        frameSyncOverflow(rxSignalPhaseCorr, ...
        frameStart, isOverflow, overflowSize, ...
        preambleMod, frameSize, header);
    
    % prevRxSignal = rxSignal;
    decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
    decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");
    
    h = 16*mode(decodedHeader(1:3)) + ...
                 4*mode(decodedHeader(4:6)) + ...
                 1*mode(decodedHeader(7:9));
            
    if (length(allHeaders) > 10)
        if (~ismember(h, allHeaders(end-10:end)) && ...
             ismember(h, possibleHeaders))
            isUnique = 1;
        end
    elseif (length(allHeaders) <= 10)
        if (~ismember(h, allHeaders) && ...
             ismember(h, possibleHeaders))
            isUnique = 1;
        end
    end
    
    if isUnique
        % plot(lags, abs(corr));
        % drawnow;
        disp("New message found!");
        allMessages = [allMessages, decodedMessage];
        allHeaders = [allHeaders; h];
    end