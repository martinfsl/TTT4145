function freqOffset = cfcPreamble(rxSignal, sampleRate, preamble, M, frameStartIndex)
    % Extract the received preamble from the signal
    % rxPreamble = rxSignal(1:length(preamble));
    rxPreamble = rxSignal(...
        frameStartIndex:(frameStartIndex + length(preamble) - 1));
    
    % Calculate phase differences between consecutive preamble symbols
    phaseDiffs = unwrap(angle(rxPreamble(2:end) .* conj(rxPreamble(1:end-1))));
    
    % Average phase difference per sample
    avgPhaseDiff = mean(diff(phaseDiffs));
    
    % Convert average phase difference to frequency offset
    % freqOffset = (avgPhaseDiff * sampleRate / (2*pi));
    freqOffset = avgPhaseDiff * sampleRate;

    disp(freqOffset);
end

