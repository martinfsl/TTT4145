function [txSignal, modulatedSignal] = SimulationTransmitter(sequence, M, rrcFilter, sps)
    % modulatedSignal = pskmod(sequence, M, pi/M, "gray");
    modulatedSignal = qammod(sequence, M, "gray");
    
    txSignal = upfirdn(modulatedSignal, rrcFilter, sps);
end