function phaseCorr = phaseCorrection(rxSignal, preamble, ...
    sps, frameStartIndex)
    
    % Use if downsampling happens in matched filtering
    % receivedPreamble = downsample(rxSignal(1:length(preamble)), sps);

    % receivedPreamble = downsample(rxSignal(1:sps*length(preamble)), sps);
    downsampledSignal = downsample(rxSignal, sps);

    % If it is the downsampled signal that is rxSignal
    % downsampledSignal = rxSignal;

    receivedPreamble = downsampledSignal(...
        frameStartIndex:(frameStartIndex + length(preamble) - 1));

    phaseDiff = angle(mean(conj(preamble) .* receivedPreamble));

    disp(phaseDiff*(360/(2*pi)));

    phaseCorr = rxSignal * exp(-1i * phaseDiff);

end