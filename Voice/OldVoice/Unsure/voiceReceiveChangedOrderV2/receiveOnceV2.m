
% rxSignal = capture(rx, numSamples);
rxSignal = rx();

rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

rxSignalCoarse = coarseCorrectionFFT(rxFiltered, M, sampleRate);

symbolSync = comm.SymbolSynchronizer(...
    'SamplesPerSymbol',sps, ...
    'NormalizedLoopBandwidth',0.01, ...
    'DampingFactor',0.7, ...
    'TimingErrorDetector','Gardner (non-data-aided)');
rxTimingSync = symbolSync(rxSignalCoarse);

rxSignalFine = fineCorrection(rxTimingSync, M, sps);

[frameStart, corrVal] = estFrameStart(rxSignalFine, ...
                        preambleMod, bitStream);
rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, frameStart);

[rxFrameSynced, rxMessage, rxPreamble, rxHeader] = ...
    frameSync(rxSignalPhaseCorr, frameStart, preambleMod, frameSize, header);

decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
decodedPreamble = pskdemod(rxPreamble, M, pi/M, "gray");
decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");

error = symerr(decodedMessage, repmat([3; 2; 1; 0], 250, 1))

% if error > 0
%     scatterplot(rxMessage);
%     drawnow;
% end

% scatterplot(rxSignalCoarse);
% scatterplot(rxSignalFine);
% scatterplot(rxTimingSync);
% scatterplot(rxSignalPhaseCorr);
% scatterplot(rxMessage);