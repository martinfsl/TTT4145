function [demodulatedBits, rxFiltered, rxFreqSync, rxPhaseSync] = ...
    SimulationReceiver(rxSignal, sampleRate, ...
    M, rrcFilter, span, sps)

    % Matched filtering
    rxFiltered = upfirdn(rxSignal, rrcFilter, 1, sps);
    rxFiltered = rxFiltered(span+1:end-span); % Removing offset from matched filter
    
    % Frequency offset correction
    rxFreqSync = FrequencyCorrection(rxFiltered, sampleRate, sps);
    
    % Phase offset correction
    phaseSync = comm.CarrierSynchronizer('Modulation', 'QAM', 'SamplesPerSymbol', sps);
    rxPhaseSync = phaseSync(rxFreqSync);
    
    % demodulatedBits = pskdemod(rxFiltered, M, pi/M, "gray");
    demodulatedBits = qamdemod(rxPhaseSync, M, "gray");
end