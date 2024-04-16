function [frameStart, corrVal, isValid, correlation, lags] = ...
    estFrameStartNew(rxSignal, preamble, bitStream, threshold)

    isValid = true;

    [correlation, lags] = xcorr(rxSignal, preamble);
    % [peakValues, peakIndices] = maxk(abs(correlation), length(preamble));
    [peakValues, peakIndices] = maxk(abs(correlation), 1000);

    for i = 1:length(peakIndices)
        if peakValues > threshold

    
    % figure(1);
    % plot(lags, abs(correlation));

    i = 1;
    while i < (length(peakIndices))
        % fprintf("%s %i \n", "While loop:", lags(peakIndices(i)) + length(bitStream) > length(rxSignal));
        if (lags(peakIndices(i)) + length(bitStream) > length(rxSignal))
            i = i + 1;
        else
            break
        end
    end

    if (lags(peakIndices(i)) + length(bitStream)) > length(rxSignal)
        frameStart = 0;
    else
        frameStart = lags(peakIndices(i)) + 1; % Adjust for MATLAB indexing
    end

    % disp(peakValues);
    % disp(lags(peakIndices));
    % disp(lags(peakIndices) + length(bitStream));
    % disp(length(rxSignal));
    % disp("Selected index");
    % disp(i);
    % disp(lags(peakIndices(i)));
    % disp(lags(peakIndices(i)) + length(bitStream));
    % disp(lags(peakIndices(i)) + length(bitStream) > length(rxSignal));

    % disp(size(peakIndices));

    if i == 1
        if(abs(lags(peakIndices(i+1) - lags(peakIndices(i)))) < length(bitStream))
            isValid = false;
        end
    elseif i == 2
        if(abs(lags(peakIndices(i) - lags(peakIndices(i-1)))) < length(bitStream))
            isValid = false;
        end
    end

    corrVal = peakValues(i);

    % plot(lags, abs(correlation));
    % drawnow;
    % plot(lags, abs(correlation));
end