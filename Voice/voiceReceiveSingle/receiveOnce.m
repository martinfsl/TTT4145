% run setupModules.m
close all

run setupModulesV2.m

% profile on

tic
[rxSignal, AAvalidData, AAOverflow] = rx();
% rxSignal = allRxSignals(:, 1);

release(coarseFreqComp);
release(symbolSync);
release(fineFreqComp);

% Matched Filtering
rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
% rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

% CFC
rxSignalCoarse = coarseFreqComp(rxFiltered);

% Timing Synchronization
rxTimingSync = symbolSync(rxSignalCoarse);

% FFC
rxSignalFine = fineFreqComp(rxTimingSync);

% Preamble detector
[idx, detmet] = detector(rxSignalFine);

frameStart = idx(1) - length(preamble) + 2;

receivedPreamble = rxSignalFine(...
            frameStart:(frameStart + length(preamble) - 1));
rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, receivedPreamble);

[rxFrameSynced, rxMessage, rxHeader] = ...
    frameSyncSingle(rxSignalPhaseCorr, frameStart, preambleMod, frameSize, header);

plot(detmet);

scatterplot(rxSignalFine);
scatterplot(rxSignalPhaseCorr);

decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");
