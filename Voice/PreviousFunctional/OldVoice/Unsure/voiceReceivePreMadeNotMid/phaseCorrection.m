function phaseCorr = phaseCorrection(rxSignal, preamble, frameStartIndex)

    receivedPreamble = rxSignal(...
        frameStartIndex:(frameStartIndex + length(preamble) - 1));

    phaseDiff = angle(mean(conj(preamble) .* receivedPreamble));

    % disp(phaseDiff*(360/(2*pi)));

    phaseCorr = rxSignal * exp(-1i * phaseDiff);

end