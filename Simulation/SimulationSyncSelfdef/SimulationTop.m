% Set-up
close all;
run("setupParameters.m");

% Setting parameters for this specific simulation
rng(1); % Setting seed
M = 4; % Setting amount of symbols
modulation = 'qam'; % Modulation scheme
bitStream = randi([0 M-1], numBits, 1); % Generating bitstream

rolloff = 0.6; span = 100; sps = 10;
rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");
% fvtool(rrcFilter);
% fvtool(rrcFilter, "impulse");

%%%------------------------------------------------------------
% Transmitter
% modulatedSignal = qammod(bitStream, M, "gray");
modulatedSignal = pskmod(bitStream, M, pi/M, "gray");

txSignal = upfirdn(modulatedSignal, rrcFilter, sps);
%%%------------------------------------------------------------

%%%------------------------------------------------------------
% Channel
SNR = 20; pOffset = 0; fOffset = 0;
%%%------------------------------------------------------------

%%%------------------------------------------------------------
% Receiver
rxSignal = SimulationChannel(txSignal, sampleRate, SNR, pOffset, fOffset);

% Coarse frequency correction
% rxSignalCoarse = coarseCorrectionFFT(rxSignal, M, sampleRate);
% rxSignalCoarse = freqCorrection(rxSignal);


% Fine frequency correction
rxSignalFine = fineCorrection(rxSignal, M, sampleRate, sps);

% rxFiltered = upfirdn(rxSignalCoarse, rrcFilter, 1, sps);
rxFiltered = upfirdn(rxSignalFine, rrcFilter, 1, sps);
rxFiltered = rxFiltered(span+1:end-span);

% rxFilteredV2 = upfirdn(rxSignalCoarse, rrcFilter, 1, 1);
% rxFilteredV2 = downsample(rxFilteredV2, sps);
% rxFilteredV2 = rxFilteredV2(span+1:end-span);

%%%------------------------------------------------------------

scatterplot(rxFiltered);
