close all;

rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

rxSignalCoarse = coarseCorrectionFFT(rxFiltered, M, sampleRate);

frameStart = estFrameStartMid(downsample(rxSignalCoarse, sps), preambleMod, ...
    bitStream, frameSize);
rxSignalPhaseCorr = phaseCorrection(rxSignalCoarse, preambleMod, ...
    sps, frameStart);

rxSignalFine = fineCorrection(rxSignalPhaseCorr, M, sps);

frameStart = estFrameStartMid(downsample(rxSignalFine, sps), preambleMod, ...
    bitStream, frameSize);
rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, ...
    sps, frameStart);

symbolSync = comm.SymbolSynchronizer(...
    "SamplesPerSymbol", sps, ...
    "NormalizedLoopBandwidth", 0.01, ...
    "DampingFactor", 1.0, ...
    "TimingErrorDetector", "Early-Late (non-data-aided)");
rxDownsampled = symbolSync(rxSignalPhaseCorr);
% rxDownsampled = downsample(rxSignalPhaseCorr, sps);

[rxFrameSynced, rxMessage, rxPreamble, rxHeader] = ...
    frameSyncMid(rxDownsampled, frameStart, preambleMod, frameSize, header);

rxFinal = rxFrameSynced;

decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
decodedPreamble = pskdemod(rxPreamble, M, pi/M, "gray");
decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");

scatterplot(rxSignalPhaseCorr);
scatterplot(rxDownsampled);
