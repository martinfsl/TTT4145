% run setupModules.m

tic
rxSignal = rx();
% rxSignal = interleaving_fewErrors.allRxSignals(:, 1);

reset(coarseFreqComp);
reset(symbolSync);
reset(fineFreqComp);

% Matched Filtering
rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

% CFC
rxSignalCoarse = coarseFreqComp(rxFiltered);

% Timing Synchronization
rxTimingSync = symbolSync(rxSignalCoarse);

% FFC
rxSignalFinePD = fineFreqComp(rxTimingSync);

% Phase Correction
[frameStartPD, corrVal]= estFrameStart(rxSignalFinePD, preambleMod, bitStream);
rxSignalPhaseCorrPD = phaseCorrection(rxSignalFinePD, preambleMod, frameStartPD, prevRxSignal);

% Frame Synchronization
[rxFrameSynced, rxMessage, rxPreamble, rxHeader] = ...
    frameSync(rxSignalPhaseCorrPD, frameStartPD, preambleMod, frameSize, header);

prevRxSignal = rxSignal;

decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
decodedPreamble = pskdemod(rxPreamble, M, pi/M, "gray");
decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");

error = symerr(decodedMessage, trueMessage)

toc