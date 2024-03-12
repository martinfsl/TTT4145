% run setupModules.m
close all

tic
[rxSignal, AAvalidData, AAOverflow] = rx();
% rxSignal = capture(rx, numSamples);
% rxSignal = interleaving_fewErrors.allRxSignals(:, 1);

% reset(coarseFreqComp);
% reset(symbolSync);
% reset(fineFreqComp);
% rxSignalTemp = rxSignal;

% Matched Filtering
rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

% CFC
rxSignalCoarse = coarseFreqComp(rxFiltered);

% for j = 1:2
%     % Timing Synchronization
%     rxTimingSync = symbolSync(rxSignalCoarse);
% 
%     % FFC
%     rxSignalFine = fineFreqComp(rxTimingSync);
% 
%     % Phase Correction
%     [frameStart, corrVal]= estFrameStart(rxSignalFine, preambleMod, bitStream);
%     rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, frameStart, prevRxSignal);
% end

% Timing Synchronization
rxTimingSync = symbolSync(rxSignalCoarse);

% FFC
rxSignalFine = fineFreqComp(rxTimingSync);

% Phase Correction
[frameStart, corrVal]= estFrameStart(rxSignalFine, preambleMod, bitStream);
rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, frameStart, prevRxSignal);

% Frame Synchronization
[rxFrameSynced, rxMessage, rxPreamble, rxHeader] = ...
    frameSync(rxSignalPhaseCorr, frameStart, preambleMod, frameSize, header);

% prevRxSignal = rxSignal;

decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
decodedPreamble = pskdemod(rxPreamble, M, pi/M, "gray");
decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");

error = symerr(decodedMessage, trueMessage)

toc

% scatterplot(rxSignalCoarse);
% scatterplot(rxFiltered);
% scatterplot(rxTimingSync);
% scatterplot(rxSignalFine);
% scatterplot(rxMessage);
% scatterplot(rP);