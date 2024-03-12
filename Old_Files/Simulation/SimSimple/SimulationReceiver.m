function [demodulatedBits, rxFiltered, finalSignal] = ...
    SimulationReceiver(rxSignal, modulationType, sampleRate, ...
    M, rrcFilter, span, sps)

    % Setting up objects for correction
    coarseCompensator = comm.CoarseFrequencyCompensator(...
        Modulation = modulationType, ...
        SampleRate = sampleRate, ...
        FrequencyResolution = 1);

    fineSynchronizer = comm.CarrierSynchronizer(...
        "DampingFactor", 0.4, ...
        "NormalizedLoopBandwidth", 0.001, ...
        "SamplesPerSymbol", 1, ...
        "Modulation", modulationType);

    phaseSync = comm.CarrierSynchronizer('Modulation', modulationType, ...
        'SamplesPerSymbol', sps);


    % Matched filtering
    rxFiltered = upfirdn(rxSignal, rrcFilter, 1, sps);
    rxFiltered = rxFiltered(span+1:end-span); % Removing offset from matched filter
    
    % Coarse frequency offset correction
    [rxCoarseComp, ~] = coarseCompensator(rxFiltered);

    % Fine frequency offset correction
    rxFineSync = fineSynchronizer(rxCoarseComp);

    % Phase offset correction
    % Can potentially be solved better with a preamble
    rxPhaseSync = phaseSync(rxCoarseComp);
    
    % In case order is changed
    finalSignal = rxFineSync;

    % Demodulation
    if contains(modulationType, 'qam')
        demodulatedBits = qamdemod(finalSignal, M, "gray");
    elseif contains(modulationType, 'dpsk')
        demodulatedBits = dpskdemod(finalSignal, M, pi/M, "gray");
    else
        demodulatedBits = pskdemod(finalSignal, M, pi/M, "gray");
    end
end