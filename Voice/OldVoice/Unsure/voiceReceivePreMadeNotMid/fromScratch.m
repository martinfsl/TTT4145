rxSignal = rx();

% Matched Filtering
rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

% CFC
coarseFreqComp = comm.CoarseFrequencyCompensator( ...
    Modulation="qpsk", ...
    SampleRate=sampleRate, ...
    FrequencyResolution=100);
rxSignalCoarse = coarseFreqComp(rxFiltered);

% Timing Synchronization
symbolSync = comm.SymbolSynchronizer(...
    'SamplesPerSymbol',sps, ...
    'NormalizedLoopBandwidth',0.01, ...
    'DampingFactor',1, ...
    'TimingErrorDetector','Gardner (non-data-aided)');
rxTimingSync = symbolSync(rxSignalCoarse);

% FFC
fineFreqComp = comm.CarrierSynchronizer( ...
    'DampingFactor',1, ...
    'NormalizedLoopBandwidth',0.01, ...
    'SamplesPerSymbol',1, ...
    'Modulation','QPSK');
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
% scatterplot(rxMessage);
