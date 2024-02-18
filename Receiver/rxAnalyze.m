close all;

rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

rxSignalCoarse = coarseCorrectionFFT(rxFiltered, M, sampleRate);

frameStart = estFrameStart(downsample(rxSignalCoarse, sps), preambleMod, bitStream);
rxSignalPhaseCorr = phaseCorrection(rxSignalCoarse, preambleMod, ...
    sps, frameStart);

rxSignalFine = fineCorrection(rxSignalPhaseCorr, M, sps);
% rxSignalFine = fineCorrection(rxSignalCoarse, M, sps);

symbolSync = comm.SymbolSynchronizer(...
    'SamplesPerSymbol',sps, ...
    'NormalizedLoopBandwidth',0.01, ...
    'DampingFactor',1.0, ...
    'TimingErrorDetector','Gardner (non-data-aided)');
rxSynced = symbolSync(rxSignalFine);
% rxSynced = symbolSync(rxSignalPhaseCorr);

% [rxFrameSynced, rxMessage] = frameSync(rxSynced, frameStart, ...
%     preambleMod, length(message));

rxDownsampled = downsample(rxSignalFine, sps);
[rxFrameSynced, rxMessage] = frameSync(rxDownsampled, frameStart, ...
    preambleMod, length(message));


rxFinal = rxFrameSynced;

decodedMessage = pskdemod(rxMessage(end-length(message)+1:end), M, pi/M, "gray");

error = sum(decodedMessage ~= message);

scatterplot(rxSignal);
scatterplot(rxFiltered);
scatterplot(rxSignalCoarse);
scatterplot(rxSignalPhaseCorr);
scatterplot(rxSignalFine);
scatterplot(rxFinal);
