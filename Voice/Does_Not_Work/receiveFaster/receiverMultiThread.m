allMessages = [];
allHeaders = repmat(33, 1, 10); % Initializing with some filler, removed at the end

global allRxSignals;
allRxSignals = [];

global AAOverflow;
AAOverflow = 0;

% % Declaring the function that shall be run to process the buffer
bufferTimer = timer('ExecutionMode', 'fixedRate', ...
                    'Period', 0.05, ... % Adjust the period to suit your needs
                    'TimerFcn', @(~,~) processBuffer());

corrVal = 0;

phase = 0;

amountReceived  = 1;

start(bufferTimer);

while length(allHeaders(11:end)) < amountReceived
    for i = 1:size(allRxSignals, 2)
        rxSignal = allRxSignals(:, i);

        release(coarseFreqComp);
        release(symbolSync);
        release(fineFreqComp);
        
        % Matched Filtering
        rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
    
        % CFC
        [rxSignalCoarse, freqOffset] = coarseFreqComp(rxFiltered);
        
        % Timing Synchronization
        rxTimingSync = symbolSync(rxSignalCoarse);
        
        % FFC
        rxSignalFine = fineFreqComp(rxTimingSync);
        
        try
            % Phase Correction
            [frameStart, corrVal, isValid, corr, lags] = ...
                estFrameStart(rxSignalFine, preambleMod, bitStream);
        catch
            continue
        end
        
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
                % plot(lags, abs(corr));
                % drawnow;
                disp("New message found!");
                allMessages = [allMessages, decodedMessage];
                allHeaders = [allHeaders, h];
                % allRxSignals = [allRxSignals, rxSignal];
    
                error = min(symerr(decodedMessage, trueMessages));
                fprintf("%s %i\n", "The error was: ", error);
            end
        end
        isUnique = 0;
        allRxSignals = allRxSignals(:, 2:end);
    end
end

stop(bufferTimer);
allHeaders = allHeaders(11:end);