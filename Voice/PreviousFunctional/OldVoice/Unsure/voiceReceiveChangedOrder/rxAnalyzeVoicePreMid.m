% rxTimingSync = symbolSync(rxSignalCoarse);
% 
% rxSignalFine = fineCorrection(rxTimingSync, M, sps);
% 
% cZero = zeros(frameSize, 1) + 1j*zeros(frameSize, 1);
% rxSignalFinePadded = [cZero; rxSignalFine; cZero];
% 
% [frameStart, corrVal] = estFrameStartMid(rxSignalFine, ...
%                         preambleMod, bitStream, frameSize);
rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, frameStart);

% Equalization
% eq = comm.LinearEqualizer('Algorithm','CMA', ...
%     'NumTaps', 5, ...
%     'StepSize',0.01);
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

% scatterplot(rxMessage);
% drawnow;