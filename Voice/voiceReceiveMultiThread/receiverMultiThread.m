allMessages = [];
allHeaders = repmat(33, 1, 10); 
allRxSignals = [];

global buffer;
buffer = [];

global bufferProcessSize;
bufferProcessSize = 5;

% % Declaring the function that shall be run to process the buffer
bufferTimer = timer('ExecutionMode', 'fixedRate', ...
                    'Period', 0.05, ... % Adjust the period to suit your needs
                    'TimerFcn', @(~,~) processBuffer());
start(bufferTimer);

corrVal = 0;

phase = 0;

amountReceived  = 10;

while length(allHeaders(11:end)) < amountReceived
    tic
    [rxSignal, AAvalidData, AAOverflow] = rx();

% Remember to comment out the initalization of allRxSignals
% i = 0;
% while i < 10
%     tic
%     rxSignal = allRxSignals(:, i+1);
%     i = i + 1;

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

    if (corrVal > 30 && isValid)

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

        if (~ismember(h, allHeaders(end-9:end)) && ...
             ismember(h, possibleHeaders))
            
            disp("Found message");
    
            allMessages = [allMessages, decodedMessage];
            allHeaders = [allHeaders, h];
            allRxSignals = [allRxSignals, rxSignal];
    
            buffer = [buffer, decodedMessage];
            disp(size(buffer));
    
            error = symerr(decodedMessage, trueMessages(:, h+1));
            fprintf("%s %i\n", "The error was: ", error);
        end
    end

    toc
end

stop(bufferTimer);
allHeaders = allHeaders(11:end);