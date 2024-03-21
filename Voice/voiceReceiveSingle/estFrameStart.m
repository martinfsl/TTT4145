function [frameStart, corrVal, isValid, correlation, lags, overflow, overflowLength] = ...
    estFrameStart(rxSignal, preamble, bitStream)

    isValid = true;

    [correlation, lags] = xcorr(rxSignal, preamble);
    % [peakValues, peakIndices] = maxk(abs(correlation), length(preamble));
    [peakValues, peakIndices] = maxk(abs(correlation), 2);

    disp(peakValues);
    disp(peakIndices);

    [peakIndices, idxIndices] = sort(peakIndices, 'ascend');

    disp(peakIndices);

    peakValTemp = [];
    for i = 1:2
        peakValTemp = peakValues(idxIndices(i));
    end
    peakValues = peakValTemp;
    
    frameStart = lags(peakIndices(1)) + 1; % Adjust for MATLAB indexing

    if(abs(lags(peakIndices(i+1) - lags(peakIndices(i)))) < length(bitStream))
        isValid = false;
    end

    corrVal = peakValues(i);

end