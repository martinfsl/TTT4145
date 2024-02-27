rxSignalPhaseCorr = phaseCorrection(rxTimingSync, preambleMod, frameStart);

fineFreqComp = comm.CarrierSynchronizer( ...
    'DampingFactor',0.7, ...
    'NormalizedLoopBandwidth',0.01, ...
    'SamplesPerSymbol',sps, ...
    'Modulation','QPSK');
rxSignalFine = fineFreqComp(rxSignalPhaseCorr);

[frameStart, corrVal] = estFrameStartMid(rxSignalFine, preambleMod, ...
    bitStream, frameSize);
rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, frameStart);

[frameStart, corrVal] = estFrameStartMid(rxSignalPhaseCorr, ...
                        preambleMod, bitStream, frameSize);
rxSignalPhaseCorr = phaseCorrection(rxSignalPhaseCorr, preambleMod, frameStart);

[rxFrameSynced, rxMessage, rxPreamble, rxHeader] = ...
    frameSyncMid(rxSignalPhaseCorr, frameStart, preambleMod, frameSize, header);

rxFinal = rxFrameSynced;

decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
decodedPreamble = pskdemod(rxPreamble, M, pi/M, "gray");
decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");

% scatterplot(rxDownsampledv2);
scatterplot(rxMessage);
drawnow;