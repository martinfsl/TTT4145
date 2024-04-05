% allMessages = []; 
allHeaders = []; 
% allRxSignals = [];
% rxSignals = [];
corrVal = 0;
isUnique = 0;

buffer = [];
bufferSize = 1;

deviceWriter = audioDeviceWriter('SampleRate', 16000);
% deviceWriter = audioDeviceWriter('SampleRate', 44100);

audioSize = 29000/4;
audioSize = 14500/4;
setup(deviceWriter, zeros(audioSize, 1));

phase = 0;

backwardView = 1;

amountReceived = 10;
while length(allHeaders) < amountReceived
    tic
    [rxSignal, AAvalidData, AAOverflow] = rx();

    % release(coarseFreqComp);
    % release(symbolSync);
    % release(fineFreqComp);
    
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
        estFrameStartNew(rxSignalFine, preambleMod, bitStream);
    
    % plot(lags, abs(corr));
    % drawnow;

    % if (corrVal > 20 && isValid)
    if (corrVal > 20 && isValid && frameStart ~= 0)
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
        
        if (length(allHeaders) > backwardView)
            if (~ismember(h, allHeaders(end-backwardView:end)) && ...
                 ismember(h, possibleHeaders))
                isUnique = 1;
            end
        elseif (length(allHeaders) <= backwardView)
            if (~ismember(h, allHeaders) && ...
                 ismember(h, possibleHeaders))
                isUnique = 1;
            end
        end

        if isUnique
            % plot(lags, abs(corr));
            % drawnow;
            % disp("New message found!");

            fprintf("%s %i \n", "New message found - header: ", h+1);

            % error = min(symerr(decodedMessage, trueMessages));
            % fprintf("%s %i %s %i \n", "The error was: ", error, " in header ", h+1);

            buffer = [buffer; decodedMessage];
            if size(buffer, 1) == bufferSize*frameSize
                disp("Playing sound");
                deviceWriter(reconstructVoiceSignal(buffer));
                buffer = [];
            end

            % recVoice = reconstructVoiceSignal(decodedMessage);
            % sound(recVoice, 16000);

            % deviceWriter(reconstructVoiceSignal(decodedMessage));

            % allMessages = [allMessages, decodedMessage];
            allHeaders = [allHeaders; h];
            % allRxSignals = [allRxSignals, rxSignal];
        end
    end
    isUnique = 0;

    toc
end

% deviceWriter(reconstructVoiceSignal(allMessages(:)));

% sound(reconstructVoiceSignal(allMessages(:)), 16000);
