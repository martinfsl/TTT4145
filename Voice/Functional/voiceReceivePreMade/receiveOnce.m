% run setupModules.m

% rxSignal = rx();
rxSignal = interleaving_fewErrors.allRxSignals(:, 1);

% Matched Filtering
rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

% CFC
rxSignalCoarse = coarseFreqComp(rxFiltered);

% Timing Synchronization
rxTimingSync = symbolSync(rxSignalCoarse);

% FFC
rxSignalFine = fineFreqComp(rxTimingSync);

% Phase Correction
[frameStart, corrVal] = estFrameStart(rxSignalFine, ...
                        preambleMod, bitStream);
rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, frameStart);

% Without equalization
[rxFrameSynced, rxMessage, rxPreamble, rxHeader] = ...
    frameSync(rxSignalPhaseCorr, frameStart, preambleMod, frameSize, header);

decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
decodedPreamble = pskdemod(rxPreamble, M, pi/M, "gray");
decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");

% scatterplot(rxSignal);
% scatterplot(rxFiltered);
% scatterplot(rxSignalCoarse);
% scatterplot(rxTimingSync);
% scatterplot(rxSignalPhaseCorr);
% scatterplot(rxSignalFine);
scatterplot(rxMessage);
