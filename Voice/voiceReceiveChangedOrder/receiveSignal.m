corrVal = 0;

while (length(allReceivedHeaders) < 4)
    rxSignal = capture(rx, numSamples);
    
    rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
    rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));
    
    rxSignalCoarse = coarseCorrectionFFT(rxFiltered, M, sampleRate);
    
    [frameStart, corrVal] = estFrameStartMid(downsample(rxSignalCoarse, sps), ...
                            preambleMod, bitStream, frameSize);
    
    if (corrVal > 100)
        run("rxAnalyzeVoicePreMid.m");
        
        if (~ismember(mode(decodedHeader), allReceivedHeaders) && ...
                ismember(mode(decodedHeader), [0, 1, 2, 3]))
            run("connectReceivedSignals.m");
        end
    end
end
