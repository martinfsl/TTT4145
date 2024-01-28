function [demodulatedBits, rxFiltered, rxPhaseSync] = ...
    SimulationReceiver(rxSignal, modulationType, sampleRate, ...
    M, rrcFilter, span, sps)

    % Setting up objects for correction
    coarseCompensator = comm.CoarseFrequencyCompensator(...
        Modulation = "qam", ...
        SampleRate = sampleRate, ...
        FrequencyResolution = 1);

    fineSynchronizer = comm.CarrierSynchronizer(...
        "DampingFactor", 0.7, ...
        "NormalizedLoopBandwidth", 0.005, ...
        "SamplesPerSymbol", sps, ...
        "Modulation", "QAM");

    phaseSync = comm.CarrierSynchronizer('Modulation', 'QAM', 'SamplesPerSymbol', sps);


    % Matched filtering
    rxFiltered = upfirdn(rxSignal, rrcFilter, 1, sps);
    rxFiltered = rxFiltered(span+1:end-span); % Removing offset from matched filter
    
    % Coarse frequency offset correction
    [rxCoarseComp, ~] = coarseCompensator(rxFiltered);

    % Fine frequency offset correction
    rxFineSync = fineSynchronizer(rxCoarseComp);

    
    % Phase offset correction
    rxPhaseSync = phaseSync(rxFineSync);
    
    % In case order is changed
    finalSignal = rxPhaseSync;

    % Demodulation
    if contains(modulationType, 'qam')
        demodulatedBits = qamdemod(finalSignal, M, "gray");
    elseif contains(modulationType, 'dpsk')
        demodulatedBits = dpskdemod(finalSignal, M, pi/M, "gray");
    else
        demodulatedBits = pskdemod(finalSignal, M, pi/M, "gray");
    end
end