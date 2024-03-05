% coarseFreqComp.release();
% symbolSync.release();
% fineFreqComp.release();

rxSignal = capture(rx, numSamples);

% Matched Filtering
rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

% CFC
rxSignalCoarse = coarseFreqComp(rxFiltered);

run rxAnalyzeVoicePreMid.m

scatterplot(rxSignal);
scatterplot(rxFiltered);
scatterplot(rxSignalCoarse);
scatterplot(rxTimingSync);
scatterplot(rxSignalFine);
scatterplot(rxSignalPhaseCorr);
scatterplot(rxMessage);