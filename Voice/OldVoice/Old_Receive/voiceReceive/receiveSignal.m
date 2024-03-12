corrVal = 0;

while (length(allReceivedHeaders) < 10)
    rxSignal = capture(rx, numSamples);
    
    rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
    rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));
    
    rxSignalCoarse = coarseCorrectionFFT(rxFiltered, M, sampleRate);
    
    [frameStart, corrVal] = estFrameStartMid(downsample(rxSignalCoarse, sps), ...
                            preambleMod, bitStream, frameSize);
    
    if (corrVal > 100)
        run("rxAnalyzeVoicePreMid.m");
        
        h = 4*mode(decodedHeader(1:3)) + 1*mode(decodedHeader(4:6));

        if (~ismember(h, allReceivedHeaders) && ...
             ismember(h, possibleHeaders))
            
            % run("connectReceivedSignals.m");
            allRxSignals = [allRxSignals, rxSignal];
            allRxMessages = [allRxMessages, rxMessage];
            allDecodedMessages = [allDecodedMessages, decodedMessage];
            allReceivedHeaders = [allReceivedHeaders; h];
        end
    end
end
