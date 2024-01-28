function demodulatedBits = SimulationReceiver(rxSignal, sampleRate, ...
    M, rrcFilter, span, sps)

    rxFiltered = upfirdn(rxSignal, rrcFilter, 1, sps);
    rxFiltered = rxFiltered(span+1:end-span); % Removing offset from matched filter
    
    % Frequency offset correction
    coarseCompensator = comm.CoarseFrequencyCompensator(...
        Modulation = "qam", ...
        SampleRate = sampleRate, ...
        FrequencyResolution = 1);
    [rxCoarseComp, ~] = coarseCompensator(rxFiltered);
    
    fineSynchronizer = comm.CarrierSynchronizer(...
        "DampingFactor", 0.7, ...
        "NormalizedLoopBandwidth", 0.005, ...
        "SamplesPerSymbol", sps, ...
        "Modulation", "QAM");
    rxFineSync = fineSynchronizer(rxCoarseComp);
    
    % Phase offset correction
    phaseSync = comm.CarrierSynchronizer('Modulation', 'QAM', 'SamplesPerSymbol', sps);
    rxPhaseSync = phaseSync(rxFineSync);
    
    % demodulatedBits = pskdemod(rxFiltered, M, pi/M, "gray");
    % demodulatedBits = qamdemod(rxCoarseComp, M, "gray");
    % demodulatedBits = qamdemod(rxFineSync, M, "gray");
    demodulatedBits = qamdemod(rxPhaseSync, M, "gray");
end