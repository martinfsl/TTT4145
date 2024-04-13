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

cZero = zeros(frameSize, 1) + 1j*zeros(frameSize, 1);
rxSignalFinePadded = [cZero; rxSignalFine; cZero];

[frameStart, corrVal] = estFrameStartMid(rxSignalFinePadded, ...
                        preambleMod, bitStream, frameSize);

run rxAnalyzeVoicePreMid.m
toc

scatterplot(rxSignal);
scatterplot(rxFiltered);
scatterplot(rxSignalCoarse);
scatterplot(rxTimingSync);
scatterplot(rxSignalFine);
scatterplot(rxSignalPhaseCorr);
scatterplot(rxMessage);