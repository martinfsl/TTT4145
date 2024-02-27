corrVal = 0;

while (length(allReceivedHeaders) < 10)
    rxSignal = capture(rx, numSamples);
    
    rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
    rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));
    
    coarseFreqComp = comm.CoarseFrequencyCompensator( ...
        Modulation="qpsk", ...
        SampleRate=sampleRate, ...
        FrequencyResolution=1);
    rxSignalCoarse = coarseFreqComp(rxFiltered);
    
    symbolSync = comm.SymbolSynchronizer(...
        'SamplesPerSymbol',sps, ...
        'NormalizedLoopBandwidth',0.01, ...
        'DampingFactor',1, ...
        'TimingErrorDetector','Early-Late (non-data-aided)');
    rxTimingSync = symbolSync(rxSignalCoarse);

    [frameStart, corrVal] = estFrameStartMid(rxTimingSync, ...
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
        end
    end
end
