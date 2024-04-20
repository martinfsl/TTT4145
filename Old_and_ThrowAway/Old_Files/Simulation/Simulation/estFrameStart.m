function frameStart = estFrameStart(rxSignal, preamble)
    % Finding preamble:
    [correlation, lags] = xcorr(rxSignal, preamble);
    % Find the peak in the correlation
    [~, peakIndex] = max(abs(correlation));
    % Calculate the index of the start of the frame
    frameStart = lags(peakIndex) + 1; % Adjust for MATLAB indexing

    % plot(lags, correlation);
end