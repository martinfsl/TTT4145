% Set-up
close all;
run("../../Setup/setupParameters.m");

rng(1); % Setting seed
M = 8; % Setting amount of symbols
modulation = 'qam'; % Modulation scheme
bitStream = randi([0 M-1], numBits, 1); % Generating bitstream

rolloff = 0.5; span = 20; sps = 5;
rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");

[txSignal, modulatedSignal] = ...
    SimulationTransmitter(bitStream, modulation, M, rrcFilter, sps);

SNR = 15; phaseOffset = 0; freqOffset = 1e5;
rxSignal = SimulationChannel(txSignal, sampleRate, SNR, phaseOffset, freqOffset);

[demodulatedBitStream, rxFiltered, rxPhaseSync] = ...
    SimulationReceiver(rxSignal, modulation, sampleRate, M, ...
    rrcFilter, span, sps);

numError = sum(bitStream ~= demodulatedBitStream);
Pb = numError/numBits;

scatterplot(modulatedSignal);
% scatterplot(rxFiltered);
% scatterplot(rxPhaseSync);