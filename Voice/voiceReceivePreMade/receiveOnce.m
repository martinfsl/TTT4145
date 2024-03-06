% coarseFreqComp.release();
% symbolSync.release();
% fineFreqComp.release();

rxSignal = capture(rx, numSamples);

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
[frameStart, corrVal] = estFrameStartMid_org(rxSignalFine, ...
                        preambleMod, bitStream, frameSize);
rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, frameStart);


% Equalization
% [rxEqualized, err] = eq(rxSignalFine);
% [frameStart, ~] = estFrameStartMid_org(rxEqualized, ...
%                         preambleMod, bitStream, frameSize);
% [rxFrameSynced, rxMessage, rxPreamble, rxHeader] = ...
%     frameSyncMid(rxSignalPhaseCorr, frameStart, preambleMod, frameSize, header);

% Without equalization
[rxFrameSynced, rxMessage, rxPreamble, rxHeader] = ...
    frameSyncMid(rxSignalPhaseCorr, frameStart, preambleMod, frameSize, header);

decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
decodedPreamble = pskdemod(rxPreamble, M, pi/M, "gray");
decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");

% scatterplot(rxSignal);
% scatterplot(rxFiltered);
% scatterplot(rxSignalCoarse);
% scatterplot(rxTimingSync);
% scatterplot(rxSignalFine);
% scatterplot(rxSignalPhaseCorr);
scatterplot(rxMessage);