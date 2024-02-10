function phaseCorr = phaseCorrection(rxSignal, preamble, ...
    sps, frameStartIndex)
    
    % Use if downsampling happens in matched filtering
    % receivedPreamble = downsample(rxSignal(1:length(preamble)), sps);

    % receivedPreamble = downsample(rxSignal(1:sps*length(preamble)), sps);
    downsampledSignal = downsample(rxSignal, sps);

    % % Finding preamble:
    % [correlation, lags] = xcorr(downsample(rxSignal, sps), preamble);
    % % Find the peak in the correlation
    % [correlationPeak, peakIndex] = max(abs(correlation));
    % % Calculate the index of the start of the frame
    % frameStartIndex = lags(peakIndex) + 1; % Adjust for MATLAB indexing

    % startIndex = (length(downsampledSignal)-length(preamble))/2 + 1;
    % endIndex = (length(downsampledSignal)-length(preamble))/2 + length(preamble);
    % receivedPreamble = downsampledSignal(startIndex:endIndex);

    receivedPreamble = downsampledSignal(...
        frameStartIndex:(frameStartIndex + length(preamble) - 1));

    phaseDiff = angle(mean(conj(preamble) .* receivedPreamble));

    % disp(phaseDiff*(360/(2*pi)));

    phaseCorr = rxSignal * exp(-1i * phaseDiff);

end