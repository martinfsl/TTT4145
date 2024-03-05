function [frameStart, corrVal] = estFrameStartMid(rxSignal, preamble, bitStream, frameSize)

    [correlation, lags] = xcorr(rxSignal, preamble);
    [peakValues, peakIndices] = maxk(abs(correlation), length(preamble));
    % [peakValues, peakIndices] = maxk(abs(correlation), 4);

    prevIndices = [0]; % Needs initial values
    i = 1;
    while i < length(peakIndices)
        if isNotValid(lags, peakIndices, prevIndices, i, frameSize, rxSignal, bitStream)
            prevIndices = [prevIndices, lags(peakIndices(i))];
            i = i + 1;
        else
            break
        end
    end

    frameStart = lags(peakIndices(i)) + 1; % Adjust for MATLAB indexing
    corrVal = peakValues(i);

    plot(lags, abs(correlation));
    % drawnow;
    % plot(lags, abs(correlation));
end

function notValid = isNotValid(lags, peakIndices, prevIndices, i, ...
                               frameSize, rxSignal, bitStream)
    % disp(prevIndices);
    % disp(abs(prevIndices - lags(peakIndices(i))));
    % disp(min(abs(prevIndices - lags(peakIndices(i)))) < frameSize);

    % disp(min(abs(prevIndices - lags(peakIndices(i)))) < frameSize);

    notValid = (lags(peakIndices(i))-frameSize) < 0 || ...
                lags(peakIndices(i)) > length(rxSignal)-length(bitStream) || ...
                min(abs(prevIndices - lags(peakIndices(i)))) < frameSize;
end