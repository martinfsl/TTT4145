% FFC
rxSignalFine = fineFreqComp(rxSignalCoarse);

% Timing Synchronization
rxTimingSync = symbolSync(rxSignalFine);

% Phase Correction
[frameStart, corrVal] = estFrameStartMid_org(rxTimingSync, ...
                        preambleMod, bitStream, frameSize);
rxSignalPhaseCorr = phaseCorrection(rxTimingSync, preambleMod, frameStart);

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