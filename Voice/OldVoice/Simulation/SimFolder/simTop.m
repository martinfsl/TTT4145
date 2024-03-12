run parameters.m
prevRxSignal = [];

txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);

r1 = pskmod(randi([0 M-1], 200, 1), M, pi/M, "gray");
r2 = pskmod(randi([0 M-1], 200, 1), M, pi/M, "gray");

pOffset = 30; fOffset = 1e5; % SNR = 15 + 10*randn(1, 1);
rxSignal = simChannel([r1; txSignal; r2], sampleRate, 15, pOffset, fOffset);

% CFC
coarseFreqComp = comm.CoarseFrequencyCompensator( ...
    Modulation="qpsk", ...
    SampleRate=sampleRate, ...
    FrequencyResolution=1);
rxSignalCoarse = coarseFreqComp(rxSignal);

rxFiltered = upfirdn(rxSignalCoarse, rrcFilter, 1, 1);
rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

% Timing Synchronization
symbolSync = comm.SymbolSynchronizer(...
    'SamplesPerSymbol',sps, ...
    'NormalizedLoopBandwidth',0.01, ...
    'DampingFactor',0.7, ...
    'TimingErrorDetector','Gardner (non-data-aided)');
rxTimingSync = symbolSync(rxFiltered);

% Phase Correction
[frameStart, corrVal]= estFrameStart(rxTimingSync, preambleMod, bitStream);
rxSignalPhaseCorr = phaseCorrection(rxTimingSync, preambleMod, frameStart, prevRxSignal);

% FFC
fineFreqComp = comm.CarrierSynchronizer( ...
    'DampingFactor',0.7, ...
    'NormalizedLoopBandwidth',0.01, ...
    'SamplesPerSymbol',1, ...
    'Modulation','QPSK');
rxSignalFine = fineFreqComp(rxSignalPhaseCorr);

% Frame Synchronization
[rxFrameSynced, rxMessage, rxPreamble, rxHeader] = ...
    frameSync(rxSignalFine, frameStart, preambleMod, frameSize, header);

prevRxSignal = rxSignal;

decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
decodedPreamble = pskdemod(rxPreamble, M, pi/M, "gray");
decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");

error = symerr(decodedMessage, message);

scatterplot(rxSignalFine);
