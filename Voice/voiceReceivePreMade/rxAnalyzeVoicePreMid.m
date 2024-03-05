% Timing Synchronization
rxTimingSync = symbolSync(rxSignalCoarse);

% FFC
rxSignalFine = fineFreqComp(rxTimingSync);

cZero = zeros(frameSize, 1) + 1j*zeros(frameSize, 1);
rxSignalFinePadded = [cZero; rxSignalFine; cZero];

% Phase Correction
[frameStart, corrVal] = estFrameStartMid(rxSignalFinePadded, ...
                        preambleMod, bitStream, frameSize);
rxSignalPhaseCorr = phaseCorrection(rxSignalFinePadded, preambleMod, frameStart);

% Equalization
% [rxEqualized, err] = eq(rxSignalPhaseCorr);
% [frameStart, ~] = estFrameStartMid(rxEqualized, ...
%                         preambleMod, bitStream, frameSize);
% [rxFrameSynced, rxMessage, rxPreamble, rxHeader] = ...
%     frameSyncMid(rxEqualized, frameStart, preambleMod, frameSize, header);

% Without equalization
[rxFrameSynced, rxMessage, rxPreamble, rxHeader] = ...
    frameSyncMid(rxSignalPhaseCorr, frameStart, preambleMod, frameSize, header);

decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
decodedPreamble = pskdemod(rxPreamble, M, pi/M, "gray");
decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");