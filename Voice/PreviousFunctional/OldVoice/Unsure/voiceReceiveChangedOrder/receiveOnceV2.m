tic
% rxSignal = capture(rx, numSamples);
rxSignal = rx();
% rxSignal = allRxSignals(:, 3);
% rxSignal = rxSignalsAll(:, 8);
% rxSignal = interleaving_fewErrors.allRxSignals(:, 3);

rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

rxSignalCoarse = coarseCorrectionFFT(rxFiltered, M, sampleRate);

rxTimingSync = symbolSync(rxSignalCoarse);

rxSignalFine = fineCorrection(rxTimingSync, M, sps);

[frameStart, corrVal] = estFrameStart(rxSignalFine, ...
                        preambleMod, bitStream, frameSize);
rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, frameStart);

[rxFrameSynced, rxMessage, rxPreamble, rxHeader] = ...
    frameSyncMid(rxSignalPhaseCorr, frameStart, preambleMod, frameSize, header);

decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
decodedPreamble = pskdemod(rxPreamble, M, pi/M, "gray");
decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");

toc

scatterplot(rxSignal);
scatterplot(rxFiltered);
scatterplot(rxSignalCoarse);
scatterplot(rxTimingSync);
scatterplot(rxSignalFine);
scatterplot(rxSignalPhaseCorr);
scatterplot(rxMessage);