function [frameStart, corrVal] = estFrameStart(rxSignal, preamble, bitStream)

    [correlation, lags] = xcorr(rxSignal, preamble);
    [peakValues, peakIndices] = maxk(abs(correlation), length(preamble));
    % [peakValues, peakIndices] = maxk(abs(correlation), 4);
    
    % figure(1);
    % plot(lags, abs(correlation));

    i = 1;
    while i < length(peakIndices)
        if lags(peakIndices(i)) > length(rxSignal)-length(bitStream) || lags(peakIndices(i)) < 0
            i = i + 1;
        else
            break
        end
    end

    if lags(peakIndices(i)) > length(rxSignal)-length(bitStream)
        frameStart = 0;
    else
        frameStart = lags(peakIndices(i)) + 1; % Adjust for MATLAB indexing
    end

    corrVal = peakValues(i);

    % plot(lags, abs(correlation));
    % drawnow;
    % plot(lags, abs(correlation));
end