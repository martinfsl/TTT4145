% allMessages = []; allHeaders = [];
corrVal = 0;

amountReceived = 2;

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

        h = 4*mode(decodedHeader(1:3)) + 1*mode(decodedHeader(4:6));
        
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

% Check error
error = 0; errors = [];

rng(1); trueMessage1 = randi([0 M-1], frameSize, 1);
rng(2); trueMessage2 = randi([0 M-1], frameSize, 1);

for i = 1:amountReceived
    if allHeaders(i) == 0
        curErr = symerr(allMessages(:, i), trueMessage1);
    elseif allHeaders(i) == 1
        curErr = symerr(allMessages(:, i), trueMessage2);
    end
    error = error + curErr;
    errors = [errors; curErr];
end