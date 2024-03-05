corrVal = 0;

while (length(allReceivedHeaders) < partitions)

% val = 0;
% while(val < 1)
%     % rxSignal = temp(:, val+1);
%     val = val + 1;

    tic
    % Sample signal
    rxSignal = capture(rx, numSamples);
    
    % rxSignal = [zeros(frameSize, 1); rxSignal; zeros(frameSize, 1)];

    % Matched filtering
    rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
    rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));
    
    % CFC
    rxSignalCoarse = coarseFreqComp(rxFiltered);

    [~, corrVal] = estFrameStartMid(rxSignalCoarse, ...
                            preambleMod, bitStream, frameSize);

    if (corrVal > 10)
        run("rxAnalyzeVoicePreMid.m");

        h = 4*mode(decodedHeader(1:3)) + 1*mode(decodedHeader(4:6));
        
        if (~ismember(h, allReceivedHeaders) && ...
             ismember(h, possibleHeaders))

            allRxSignals = [allRxSignals, rxSignal];
            allRxMessages = [allRxMessages, rxMessage];
            allDecodedMessages = [allDecodedMessages, decodedMessage];
            allReceivedHeaders = [allReceivedHeaders; h];

            % scatterplot(rxMessage);
            % drawnow;
            % 
            % eyediagram(rxMessage, 2);
            % drawnow;
        end

        scatterplot(rxMessage);
        drawnow;

        % eyediagram(rxMessage, 2);
        % drawnow;
    end
    toc
end