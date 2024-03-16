function [frameStart, isOverflow, overflowSize, corrVal, isValid, correlation, lags] = ...
    estFrameStart(rxSignal, preamble, bitStream)

    isValid = true;

    isOverflow = 0; overflowSize = 0;

    [correlation, lags] = xcorr(rxSignal, preamble);
    % [peakValues, peakIndices] = maxk(abs(correlation), length(preamble));
    [peakValues, peakIndices] = maxk(abs(correlation), 5);
    
    % figure(1);
    % plot(lags, abs(correlation));

    % disp(size(peakIndices));

    % Checks if two peaks are too close to call the signal detected
    if(abs(lags(peakIndices(2) - lags(peakIndices(1)))) < length(bitStream))
        isValid = false;
    end

    corrVal = peakValues(1);
    frameStart = lags(peakIndices(1)) + 1;

    if lags(peakIndices(1)) > length(rxSignal) - length(bitStream)
        isOverflow = 1;
        overflowSize = length(bitStream) ...
            - (length(rxSignal) - lags(peakIndices(1))) - 400 - 1;
    end

    % plot(lags, abs(correlation));
    % drawnow;
    % plot(lags, abs(correlation));
end