% run setupModules.m
close all

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

% Phase Correction
[frameStart, corrVal, isValid, corr, lags]= estFrameStart(rxSignalFine, preambleMod, bitStream);
rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, frameStart, prevRxSignal);

% Frame Synchronization
[rxFrameSynced, rxMessage, rxHeader] = ...
    frameSync(rxSignalPhaseCorr, frameStart, preambleMod, frameSize, header);

% prevRxSignal = rxSignal;

decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");
% decodedMessage = pskdemodSelf(rxMessage);
% decodedHeader = pskdemodSelf(rxHeader);

toc

% profile viewer

% scatterplot(rxSignalCoarse);
% scatterplot(rxTimingSync);
% scatterplot(rxSignalFine);
% scatterplot(rxSignalPhaseCorr);
% scatterplot(rxMessage);

error = min(symerr(decodedMessage, trueMessages));
fprintf("%s %i\n", "The error was: ", error);
