rxSignal = capture(rx, numSamples);
% rxSignal = allRxSignals(:, 3);

rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

rxSignalCoarse = coarseCorrectionFFT(rxFiltered, M, sampleRate);

[frameStart, corrVal] = estFrameStartMid(downsample(rxSignalCoarse, sps), ...
                        preambleMod, bitStream, frameSize);
rxSignalPhaseCorr = phaseCorrection(rxSignalCoarse, preambleMod, frameStart);

symbolSync = comm.SymbolSynchronizer(...
    'SamplesPerSymbol',sps, ...
    'NormalizedLoopBandwidth',0.005, ...
    'DampingFactor',1, ...
    'TimingErrorDetector','Early-Late (non-data-aided)');
rxTimingSync = symbolSync(rxSignalPhaseCorr);
% rxTimingSync = symbolSync(rxSignalCoarse);
% rxTimingSync = downsample(rxSignalPhaseCorr, sps);

rxSignalFine = fineCorrection(rxTimingSync, M, sps);

[frameStart, corrVal] = estFrameStartMid(rxSignalFine, ...
                        preambleMod, bitStream, frameSize);
rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, frameStart);

[rxFrameSynced, rxMessage, rxPreamble, rxHeader] = ...
    frameSyncMid(rxSignalPhaseCorr, frameStart, preambleMod, frameSize, header);

rxFinal = rxFrameSynced;

decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
decodedPreamble = pskdemod(rxPreamble, M, pi/M, "gray");
decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");

% error = sum(decodedMessage ~= [message1; message2]);
% error_pb = error/(2*frameSize);

% scatterplot(rxSignal);
% scatterplot(rxFiltered);
% scatterplot(rxSignalCoarse);
scatterplot(rxTimingSync);
scatterplot(rxSignalFine);
% scatterplot(rxSignalPhaseCorr);
% scatterplot(rxMessage);