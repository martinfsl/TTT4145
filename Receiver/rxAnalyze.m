close all;

rxSignalCoarse = coarseCorrectionFFT(rxSignal, M, sampleRate);

rxFiltered = upfirdn(rxSignalCoarse, rrcFilter, 1, 1);
rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

frameStart = estFrameStart(downsample(rxFiltered, sps), preambleMod);
rxSignalPhaseCorr = phaseCorrection(rxFiltered, preambleMod, ...
    sps, frameStart);

rxSignalFine = fineCorrection(rxSignalPhaseCorr, M, sps);

symbolSync = comm.SymbolSynchronizer(...
    'SamplesPerSymbol',sps, ...
    'NormalizedLoopBandwidth',0.01, ...
    'DampingFactor',1.0, ...
    'TimingErrorDetector','Gardner (non-data-aided)');
rxSynced = symbolSync(rxSignalFine);

[rxFrameSynced, rxMessage] = frameSync(rxSynced, frameStart, ...
    preambleMod, length(message));

rxFinal = rxFrameSynced;

decodedMessage = pskdemod(rxMessage(end-length(message)+1:end), M, pi/M, "gray");