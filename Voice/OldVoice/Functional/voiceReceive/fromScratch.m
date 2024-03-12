% run setupModules.m

tic
rxSignal = rx();
% rxSignal = interleaving_fewErrors.allRxSignals(:, 1);

% Matched Filtering
rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

% CFC
coarseFreqComp = comm.CoarseFrequencyCompensator( ...
    Modulation="qpsk", ...
    SampleRate=sampleRate, ...
    FrequencyResolution=40);
rxSignalCoarse = coarseFreqComp(rxFiltered);

% Preamble detection
pd = comm.PreambleDetector(preambleMod, "Threshold", 15.5);

[idx, ~] = pd(rxSignalCoarse);
frameStartPD = idx(1) + 1 - length(preamble);

rxSignalPhaseCorr = phaseCorrection(rxSignalCoarse, preambleMod, frameStartPD);

% FFC
fineFreqComp = comm.CarrierSynchronizer( ...
    'DampingFactor',0.7, ...
    'NormalizedLoopBandwidth',0.01, ...
    'SamplesPerSymbol',sps, ...
    'Modulation','QPSK');
rxSignalFine = fineFreqComp(rxSignalPhaseCorr);

% Timing Synchronization
symbolSync = comm.SymbolSynchronizer(...
    'SamplesPerSymbol',sps, ...
    'NormalizedLoopBandwidth',0.01, ...
    'DampingFactor',0.7, ...
    'TimingErrorDetector','Gardner (non-data-aided)');
rxTimingSync = symbolSync(rxSignalFine);

[idx, detmet] = pd(rxSignalCoarse);
frameStartPD = idx(1) + 1 - length(preamble);

% [rxFrameSynced, rxMessage, rxPreamble, rxHeader] = ...
%     frameSync(rxSignalPhaseCorr, frameStart, preambleMod, frameSize, header);
% decodedMessageWorks = pskdemod(rxMessage, M, pi/M, "gray");


scatterplot(rxFiltered);
scatterplot(rxSignalCoarse);
scatterplot(rxSignalPhaseCorr);
scatterplot(rxSignalFine);
scatterplot(rxTimingSync);
