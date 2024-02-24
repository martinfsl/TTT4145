rxSignalPhaseCorr = phaseCorrection(rxSignalCoarse, preambleMod, ...
    sps, frameStart);

rxSignalFine = fineCorrection(rxSignalPhaseCorr, M, sps);

[frameStart, corrVal] = estFrameStartMid(downsample(rxSignalFine, sps), preambleMod, ...
    bitStream, frameSize);
rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, ...
    sps, frameStart);

symbolSync = comm.SymbolSynchronizer(...
    'SamplesPerSymbol',sps, ...
    'NormalizedLoopBandwidth',0.01, ...
    'DampingFactor',1.0, ...
    'TimingErrorDetector','Early-Late (non-data-aided)');
rxDownsampled = symbolSync(rxSignalPhaseCorr);

% rxDownsampledv2 = downsample(rxSignalPhaseCorr, sps);

[rxFrameSynced, rxMessage, rxPreamble, rxHeader] = ...
    frameSyncMid(rxDownsampled, frameStart, preambleMod, frameSize, header);

rxFinal = rxFrameSynced;

decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
decodedPreamble = pskdemod(rxPreamble, M, pi/M, "gray");
decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");

scatterplot(rxDownsampled);
drawnow;
% scatterplot(rxDownsampledv2);
% scatterplot(rxMessage);