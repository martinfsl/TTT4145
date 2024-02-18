close all;

rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

rxSignalCoarse = coarseCorrectionFFT(rxFiltered, M, sampleRate);

frameStart = estFrameStart(downsample(rxSignalCoarse, sps), preambleMod, bitStream);
rxSignalPhaseCorr = phaseCorrection(rxSignalCoarse, preambleMod, ...
    sps, frameStart);

rxSignalFine = fineCorrection(rxSignalPhaseCorr, M, sps);

frameStart = estFrameStart(downsample(rxSignalFine, sps), preambleMod, bitStream);
rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, ...
    sps, frameStart);

symbolSync = comm.SymbolSynchronizer(...
    'SamplesPerSymbol', sps, ...
    'NormalizedLoopBandwidth', 0.01, ...
    'DampingFactor', 1, ...
    'TimingErrorDetector', 'Gardner (non-data-aided)');
% rxSynced = symbolSync(rxSignalFine);
% [rxFrameSynced, rxMessage] = frameSync(rxSynced, frameStart, ...
%     preambleMod, length(message));

rxDownsampled = downsample(rxSignalFine, sps);
[rxFrameSynced, rxMessage] = frameSync(rxDownsampled, frameStart, ...
    preambleMod, length(message));

rxFinal = rxFrameSynced;

decodedMessage = pskdemod(rxMessage(end-length(message)+1:end), M, pi/M, "gray");
