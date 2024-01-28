% Set-up
close all;
run("../../Setup/setupParameters.m");

rng(1); % Setting seed
M = 8; % Setting amount of symbols
bitStream = randi([0 M-1], numBits, 1); % Generating bitstream

rolloff = 0.5; span = 20; sps = 5; k = log2(M);
rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");

[txSignal, modulatedSignal] = SimulationTransmitter(bitStream, M, rrcFilter, sps);

rxSignal = SimulationChannel(txSignal, sampleRate, 15, 35, 0);

[demodulatedBitStream, rxFiltered, rxFreqSync, rxPhaseSync] = ...
    SimulationReceiver(rxSignal, sampleRate, M, ...
    rrcFilter, span, sps);

numError = sum(bitStream ~= demodulatedBitStream);
Pb = numError/numBits;

scatterplot(modulatedSignal);
scatterplot(rxFiltered);
scatterplot(rxFreqSync);