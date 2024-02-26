rxSignal = capture(rx, numSamples);
% rxSignal = allRxSignals(:, 3);

rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

rxSignalCoarse = coarseCorrectionFFT(rxFiltered, M, sampleRate);

symbolSync = comm.SymbolSynchronizer(...
    'SamplesPerSymbol',sps, ...
    'NormalizedLoopBandwidth',0.01, ...
    'DampingFactor',1, ...
    'TimingErrorDetector','Early-Late (non-data-aided)');
rxTimingSync = symbolSync(rxSignalCoarse);

[frameStart, corrVal] = estFrameStartMid(rxTimingSync, ...
                        preambleMod, bitStream, frameSize);
rxSignalPhaseCorr = phaseCorrection(rxTimingSync, preambleMod, frameStart);

rxSignalFine = fineCorrection(rxSignalPhaseCorr, M, sps);

% [frameStart, corrVal] = estFrameStartMid(rxSignalFine, preambleMod, ...
%                         bitStream, frameSize);
% rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, frameStart);

% rxDownsampledv2 = downsample(rxSignalPhaseCorr, sps);
% rxDownsampled = rxDownsampledv2;

[rxFrameSynced, rxMessage, rxPreamble, rxHeader] = ...
    frameSyncMid(rxSignalPhaseCorr, frameStart, preambleMod, frameSize, header);

rxFinal = rxFrameSynced;

decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
decodedPreamble = pskdemod(rxPreamble, M, pi/M, "gray");
decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");

scatterplot(rxSignal);
scatterplot(rxFiltered);
scatterplot(rxSignalCoarse);
scatterplot(rxTimingSync);
scatterplot(rxSignalPhaseCorr);
scatterplot(rxSignalFine);