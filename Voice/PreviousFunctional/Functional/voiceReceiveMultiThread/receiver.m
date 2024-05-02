allMessages = []; allHeaders = []; 
allRxSignals = [];
% rxSignals = [];
corrVal = 0;
isUnique = 0;

phase = 0; freqOffset = 0;

amountReceived = 10;

while length(allHeaders) < amountReceived
    tic
    [rxSignal, AAvalidData, AAOverflow] = rx();

    release(coarseFreqComp);
    release(symbolSync);
    release(fineFreqComp);
    
    % Matched Filtering
    rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
    % rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));
    
    t = [0:length(rxFiltered)-1]'/sampleRate;
    rxFilteredCorr = rxFiltered .* exp(-1i*2*pi*freqOffset*t);

    % CFC
    [rxSignalCoarse, freqOffset] = coarseFreqComp(rxFilteredCorr);
    
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
        % decodedMessage = pskdemodSelf(rxMessage);
        % decodedHeader = pskdemodSelf(rxHeader);

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
            allRxSignals = [allRxSignals, rxSignal];

            error = min(symerr(decodedMessage, trueMessages));
            fprintf("%s %i\n", "The error was: ", error);

            % recVoice = reconstructVoiceSignal(decodedMessage);
            % sound(recVoice, 16000);
        end
    end
    isUnique = 0;

    toc
end
