function [txSignal, modulatedSignal] = ...
    SimulationTransmitter(sequence, modulationType, M, rrcFilter, sps)

    if contains(modulationType, 'qam')
        modulatedSignal = qammod(sequence, M, "gray");
    elseif contains(modulationType, 'dpsk')
        modulatedSignal = dpskmod(sequence, M, pi/M, "gray");
    else
        modulatedSignal = pskmod(sequence, M, pi/M, "gray");
    end
    
    txSignal = upfirdn(modulatedSignal, rrcFilter, sps);
end