% Set-up
close all;
run("../../Setup/setupParameters.m");

rng(1); % Setting seed
M = 4; % Setting amount of symbols
bitStream = randi([0 M-1], numBits, 1); % Generating bitstream

rolloff = 0.5; span = 20; sps = 5; k = log2(M);
rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");

txSignal = SimulationTransmitter(bitStream, M, rrcFilter, sps);

rxSignal = SimulationChannel(txSignal, sampleRate, 0, 1e5);

demodulatedBitStream = SimulationReceiver(rxSignal, sampleRate, M, ...
    rrcFilter, span, sps);

numError = sum(bitStream ~= demodulatedBitStream);
Pb = numError/numBits;