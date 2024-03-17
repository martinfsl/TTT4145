% run setupModules.m
close all

tic
% [rxSignal, AAvalidData, AAOverflow] = rx();
rxSignal = allRxSignals(:, 40);

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

% Phase Correction
[frameStart, corrVal, isValid, corr, lags]= estFrameStart(rxSignalFine, preambleMod, bitStream);

% plot(lags, abs(corr));

rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, frameStart, prevRxSignal);

% Frame Synchronization
[rxFrameSynced, rxMessage, rxHeader, rxPreamble] = ...
    frameSync(rxSignalPhaseCorr, frameStart, preambleMod, frameSize, header);

% prevRxSignal = rxSignal;

decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");

toc

% scatterplot(rxTimingSync);
% scatterplot(rxSignalFine);
% scatterplot(rxPreamble);
% scatterplot(rxSignalPhaseCorr);
scatterplot(rxMessage);
