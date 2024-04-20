% Set-up
close all;
run("setupParameters.m");

rng(1); % Setting seed
M = 8; % Setting amount of symbols
modulation = 'qam'; % Modulation scheme
bitStream = randi([0 M-1], numBits, 1); % Generating bitstream

rolloff = 0.5; span = 100; sps = 10;
rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");
% fvtool(rrcFilter, "impulse");

[txSignal, modulatedSignal] = ...
    SimulationTransmitter(bitStream, modulation, M, rrcFilter, sps);

SNR = 15; phaseOffset = 0; freqOffset = 1e5;
rxSignal = SimulationChannel(txSignal, sampleRate, SNR, phaseOffset, freqOffset);

[demodulatedBitStream, rxFiltered, rxSynced] = ...
    SimulationReceiver(rxSignal, modulation, sampleRate, M, ...
    rrcFilter, span, sps);

numError = sum(bitStream ~= demodulatedBitStream);
Pb = numError/numBits;

% scatterplot(modulatedSignal);
% scatterplot(rxFiltered);
% scatterplot(rxSynced);