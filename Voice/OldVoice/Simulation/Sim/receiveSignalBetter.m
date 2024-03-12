reset(coarseFreqComp);
reset(symbolSync);
reset(fineFreqComp);

SNR = 20; pOffset = 40; fOffset = 1e5;
rxSignal = simChannel(txSignal, sampleRate, SNR, pOffset, fOffset);

[~, freqOffsetEstimate] = coarseCorrectionFFT(rxSignal, M, sampleRate);

t = (0:length(rxSignal)-1)'/sampleRate;
rxSignal = rxSignal .* exp(-1i * 2*pi*freqOffsetEstimate * t);

% Matched Filtering
rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

% CFC
coarseFreqComp = comm.CoarseFrequencyCompensator( ...
    Modulation="qpsk", ...
    SampleRate=sampleRate*sps, ...
    Algorithm="FFT-based", ...
    FrequencyResolution=100);
[rxSignalCoarse, freqOffsetEstimatePM] = coarseFreqComp(rxFiltered);

% Timing Synchronization
rxTimingSync = symbolSync(rxSignalCoarse);

% FFC
rxSignalFine = fineFreqComp(rxTimingSync);

% Phase Correction
[frameStart, corrVal]= estFrameStart(rxSignalFine, preambleMod, ...
                                    [preamble; header; message;]);
rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, frameStart, prevRxSignal);

% Frame Synchronization
[rxFrameSynced, rxMessage, rxPreamble, rxHeader] = ...
    frameSync(rxSignalPhaseCorr, frameStart, preambleMod, frameSize, header);

scatterplot(rxMessage);