function [frameSynced, message] = frameSync(rxSignal, frameStart, preamble, messageLength)
    
    % [correlation, lags] = xcorr(rxSignal, preamble);
    % % Find the peak in the correlation
    % [correlationPeak, peakIndex] = max(abs(correlation));
    % % Calculate the index of the start of the frame
    % frameStartIndex = lags(peakIndex) + 1; % Adjust for MATLAB indexing

    message = rxSignal(frameStart:(frameStart+length(preamble)+messageLength-1));

    frameSynced = rxSignal;
end