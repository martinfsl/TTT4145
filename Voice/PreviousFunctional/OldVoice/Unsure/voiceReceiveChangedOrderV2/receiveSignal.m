corrVal = 0;

while (length(allReceivedHeaders) < partitions)
    tic
    rxSignal = capture(rx, numSamples);

% val = 0;
% while(val < 10)
%     rxSignal = temp(:, val+1);
%     val = val + 1;

    rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
    rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));
    
    rxSignalCoarse = coarseCorrectionFFT(rxFiltered, M, sampleRate);
    
    rxTimingSync = symbolSync(rxSignalCoarse);

    rxSignalFine = fineCorrection(rxTimingSync, M, sps);
    
    % cZero = zeros(frameSize, 1) + 1j*zeros(frameSize, 1);
    % rxSignalFinePadded = [cZero; rxSignalFine; cZero];
    
    [frameStart, corrVal] = estFrameStartMid(rxSignalFine, ...
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
        end

        scatterplot(rxMessage);
        drawnow;

        % eyediagram(rxMessage, 2);
        % drawnow;
    end
    toc
end
