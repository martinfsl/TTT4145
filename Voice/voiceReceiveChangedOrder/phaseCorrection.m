function phaseCorr = phaseCorrection(rxSignal, preamble, frameStartIndex)
    
    % Use if downsampling happens in matched filtering
    % receivedPreamble = downsample(rxSignal(1:length(preamble)), sps);

    % If it is the downsampled signal that is rxSignal
    % downsampledSignal = rxSignal;

    receivedPreamble = rxSignal(...
        frameStartIndex:(frameStartIndex + length(preamble) - 1));

    phaseDiff = angle(mean(conj(preamble) .* receivedPreamble));

    % disp(phaseDiff*(360/(2*pi)));

    phaseCorr = rxSignal * exp(-1i * phaseDiff);

end