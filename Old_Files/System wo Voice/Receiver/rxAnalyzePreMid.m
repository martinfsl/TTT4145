close all;

rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

rxSignalCoarse = coarseCorrectionFFT(rxFiltered, M, sampleRate);

frameStart = estFrameStartMid(downsample(rxSignalCoarse, sps), preambleMod, ...
    bitStream, frameSize);
rxSignalPhaseCorr = phaseCorrection(rxSignalCoarse, preambleMod, ...
    sps, frameStart);

rxSignalFine = fineCorrection(rxSignalPhaseCorr, M, sps);

frameStart = estFrameStartMid(downsample(rxSignalFine, sps), preambleMod, ...
    bitStream, frameSize);
rxSignalPhaseCorr = phaseCorrection(rxSignalFine, preambleMod, ...
    sps, frameStart);

rxDownsampled = downsample(rxSignalFine, sps);
[rxFrameSynced, rxMessage, rxPreamble] = frameSyncMid(rxDownsampled, frameStart, ...
    preambleMod, frameSize);

rxFinal = rxFrameSynced;

decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");
decodedPreamble = pskdemod(rxPreamble, M, pi/M, "gray");

diffPreamble = [preamble, decodedPreamble];
diffMessage = [txMessage, decodedMessage];

error = sum(decodedMessage ~= txMessage) + ...
    sum(decodedPreamble ~= preamble);
error_Pb = error/length(bitStream);
