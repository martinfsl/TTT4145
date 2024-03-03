% rxSignal = capture(rx, numSamples);
% rxSignal = allRxSignals(:, 3);
% rxSignal = rxSignalsAll(:, 8);
% rxSignal = interleaving_fewErrors.allRxSignals(:, 5);

rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

rxSignalCoarse = coarseCorrectionFFT(rxFiltered, M, sampleRate);

symbolSync = comm.SymbolSynchronizer(...
    'SamplesPerSymbol',sps, ...
    'NormalizedLoopBandwidth',0.005, ...
    'DampingFactor',1, ...
    'TimingErrorDetector','Early-Late (non-data-aided)');
rxTimingSync = symbolSync(rxSignalCoarse);

rxSignalFine = fineCorrection(rxTimingSync, M, sps);

[frameStart, corrVal] = estFrameStartMid(rxSignalFine, ...
                        preambleMod, bitStream, frameSize);
rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, frameStart);

eq = comm.LinearEqualizer('Algorithm','CMA', ...
    'NumTaps', 5, ...
    'StepSize',0.01);
[rxEqualized, err] = eq(rxSignalPhaseCorr);

[frameStart, ~] = estFrameStartMid(rxEqualized, ...
                        preambleMod, bitStream, frameSize);

[rxFrameSynced, rxMessage, rxPreamble, rxHeader] = ...
    frameSyncMid(rxEqualized, frameStart, preambleMod, frameSize, header);

rxFinal = rxFrameSynced;

decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
decodedPreamble = pskdemod(rxPreamble, M, pi/M, "gray");
decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");

% error = sum(decodedMessage ~= [message1; message2]);
% error_pb = error/(2*frameSize);

% scatterplot(rxSignal);
% scatterplot(rxFiltered);
% scatterplot(rxSignalCoarse);
% scatterplot(rxTimingSync);
% scatterplot(rxSignalFine);
% scatterplot(rxSignalPhaseCorr);
scatterplot(rxMessage);
drawnow;

eyediagram(rxMessage, 2);