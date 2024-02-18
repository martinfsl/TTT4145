function frameStart = estFrameStart(rxSignal, preamble, bitStream)
    % Finding preamble:
    [correlation, lags] = xcorr(rxSignal, preamble);
    % Find the peak in the correlation
    % [~, peakIndex] = max(abs(correlation));
    [peakValues, peakIndices] = maxk(abs(correlation), 3);
    % Calculate the index of the start of the frame

    i = 1;
    while i < 3
        % fprintf("%i %i \n", length(rxSignal), lags(peakIndices(i)));
        if lags(peakIndices(i)) < 0 || lags(peakIndices(i)) > length(rxSignal)-length(bitStream)
            i = i + 1;
        else
            break
        end
    end

    frameStart = lags(peakIndices(i)) + 1; % Adjust for MATLAB indexing

    plot(lags, abs(correlation));
end