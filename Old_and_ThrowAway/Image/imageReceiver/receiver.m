allMessages = []; allHeaders = []; 
allRxSignals = [];
% rxSignals = [];
corrVal = 0;
isUnique = 0;

phase = 0;

amountReceived = 18;

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
    [frameStart, corrVal, isValid, corr, lags] = ...
        estFrameStart(rxSignalFine, preambleMod, bitStream);
    
    % plot(lags, abs(corr));
    % drawnow;

    if (corrVal > 30 && isValid)
        % plot(lags, abs(corr));
        % drawnow;

        rxSignalFine = rxSignalFine .* exp(-1i * phase);

        [rxSignalPhaseCorr, phase] = phaseCorrection(rxSignalFine, preambleMod, ...
                                            frameStart, prevRxSignal);

        % Frame Synchronization
        [rxFrameSynced, rxMessage, rxHeader] = ...
            frameSync(rxSignalPhaseCorr, frameStart, preambleMod, frameSize, header);
        
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
            disp("New message found!");
            allMessages = [allMessages, decodedMessage];
            allHeaders = [allHeaders, h];
            allRxSignals = [allRxSignals, rxSignal];
        end
    end
    isUnique = 0;

    toc
end

run processData.m

% decompressedImage = reconstructImage(allMessages);
% imshow(decompressedImage, []);
