function [frameStart, corrVal] = estFrameStartMid_org(rxSignal, preamble, bitStream, frameSize)

    [correlation, lags] = xcorr(rxSignal, preamble);
    [peakValues, peakIndices] = maxk(abs(correlation), length(preamble));
    % [peakValues, peakIndices] = maxk(abs(correlation), 4);

    i = 1;
    while i < length(peakIndices)
        if (lags(peakIndices(i))-frameSize) < 0 || lags(peakIndices(i)) > length(rxSignal)-length(bitStream)
            i = i + 1;
        else
            break
        end
    end

    frameStart = lags(peakIndices(i)) + 1; % Adjust for MATLAB indexing
    corrVal = peakValues(i);

    % plot(lags, abs(correlation));
    % drawnow;
    % plot(lags, abs(correlation));
end