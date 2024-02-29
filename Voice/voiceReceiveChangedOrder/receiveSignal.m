corrVal = 0;

while (length(allReceivedHeaders) < 10)
    rxSignal = capture(rx, numSamples);

% val = 0;
% while(val < 10)
%     rxSignal = temp(:, val+1);
%     val = val + 1;

    rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
    rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));
    
    rxSignalCoarse = coarseCorrectionFFT(rxFiltered, M, sampleRate);
    
    symbolSync = comm.SymbolSynchronizer(...
        'SamplesPerSymbol',sps, ...
        'NormalizedLoopBandwidth',0.005, ...
        'DampingFactor',1, ...
        'TimingErrorDetector','Early-Late (non-data-aided)');
    rxTimingSync = symbolSync(rxSignalCoarse);

    rxSignalFine = fineCorrection(rxTimingSync, M, sps);

    [frameStart, corrVal] = estFrameStartMid(rxSignalFine, ...
                            preambleMod, bitStream, frameSize);
    
    if (corrVal > 100)
        run("rxAnalyzeVoicePreMid.m");

        h = 4*mode(decodedHeader(1:3)) + 1*mode(decodedHeader(4:6));
        
        if (~ismember(h, allReceivedHeaders) && ...
             ismember(h, possibleHeaders))

            allRxSignals = [allRxSignals, rxSignal];
            allRxMessages = [allRxMessages, rxMessage];
            allDecodedMessages = [allDecodedMessages, decodedMessage];
            allReceivedHeaders = [allReceivedHeaders; h];
            % run("connectReceivedSignals.m");
        end

        scatterplot(rxMessage);
        drawnow;

        eyediagram(rxMessage, 2);
        drawnow;
    end
end
