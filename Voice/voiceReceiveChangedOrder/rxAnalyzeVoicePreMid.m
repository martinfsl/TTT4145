rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, frameStart);

[rxFrameSynced, rxMessage, rxPreamble, rxHeader] = ...
    frameSyncMid(rxSignalPhaseCorr, frameStart, preambleMod, frameSize, header);

rxFinal = rxFrameSynced;

decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
decodedPreamble = pskdemod(rxPreamble, M, pi/M, "gray");
decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");

% scatterplot(rxMessage);
% drawnow;