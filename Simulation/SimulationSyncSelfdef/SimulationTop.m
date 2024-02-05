% Set-up
close all;
run("setupParameters.m");

% Setting parameters for this specific simulation
% rng(1); % Setting seed
M = 4; % Setting amount of symbols
modulation = 'psk'; % Modulation scheme
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
SNR = 20; pOffset = 0; fOffset = 150;

% % Rician Channel
% ricianchan = comm.RicianChannel( ...
%     'SampleRate',sampleRate, ...
%     'PathDelays',[0.0 0.5 1.2]*1e-6, ...
%     'AveragePathGains',[0.1 0.5 0.2], ...
%     'KFactor',2.8, ...
%     'DirectPathDopplerShift',5.0, ...
%     'DirectPathInitialPhase',0.5, ...
%     'MaximumDopplerShift',50, ...
%     'DopplerSpectrum',doppler('Bell', 8), ...
%     'RandomStream','mt19937ar with seed', ...
%     'Seed',73, ...
%     'PathGainsOutputPort',true);
% SignalThroughChannel = ricianchan(txSignal);
%%%------------------------------------------------------------

%%%------------------------------------------------------------
% Receiver
rxSignal = SimulationChannel(txSignal, sampleRate, SNR, pOffset, fOffset);

% rxSignal = SignalThroughChannel;

% Coarse frequency correction
rxSignalCoarse = coarseCorrectionFFT(rxSignal, M, sampleRate);

% Fine frequency correction
rxSignalFine = fineCorrection(rxSignalCoarse, M, sps);

% rxFiltered = upfirdn(rxSignalCoarse, rrcFilter, 1, sps);
rxFiltered = upfirdn(rxSignalFine, rrcFilter, 1, sps);
% rxFiltered = upfirdn(rxSignal, rrcFilter, 1, sps);
rxFiltered = rxFiltered(span+1:end-span);

% rxFilteredV2 = upfirdn(rxSignalCoarse, rrcFilter, 1, 1);
% rxFilteredV2 = downsample(rxFilteredV2, sps);
% rxFilteredV2 = rxFilteredV2(span+1:end-span);

%%%------------------------------------------------------------

scatterplot(rxFiltered);

eyediagram(rxFiltered, 2);

% offsetEstimates = freqCorrection(rxSignal, sampleRate, M);

%%%------------------------------------------------------------
% Demodulate

% demodulatedBits = qamdemod(rxFiltered, M, "gray");
demodulatedBits = pskdemod(rxFiltered, M, pi/M, "gray");

error = sum(demodulatedBits ~= bitStream);
Pb = error/numBits;

%%%------------------------------------------------------------

