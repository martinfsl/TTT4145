% Set-up
close all;
run("setupParameters.m");

% Setting parameters for this specific simulation
rng(1); % Setting seed
M = 4; % Setting amount of symbols
modulation = 'psk'; % Modulation scheme
bitStream = randi([0 M-1], numBits, 1); % Generating bitstream

rolloff = 0.6; span = 5; sps = 4;
rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");
% fvtool(rrcFilter);
% fvtool(rrcFilter, "impulse");

% preamble = [ones(30, 1); zeros(30, 1)];
preamble = [1; 1; 1; 1; 1; 0; 0; 1; 1; 0; 1; 0; 1];
preamble = repmat(preamble, 4, 1);
bitStream = [preamble; bitStream]; % Preamble at the start
% bitStream = [bitStream(1:(end/2)); preamble; bitStream((end/2 + 1):end)];

preambleMod = pskmod(preamble, M, pi/M, "gray");

%%%------------------------------------------------------------
% Transmitter
% modulatedSignal = qammod(bitStream, M, "gray");
modulatedSignal = pskmod(bitStream, M, pi/M, "gray");

txSignal = upfirdn(modulatedSignal, rrcFilter, sps);
%%%------------------------------------------------------------

%%%------------------------------------------------------------
% Channel
SNR = 200; pOffset = 0; fOffset = 0;

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

% rxFiltered = upfirdn(rxSignal, rrcFilter, 1, sps);
% rxFiltered = rxFiltered(span+1:end-span);

% Coarse frequency correction
rxSignalCoarse = coarseCorrectionFFT(rxSignal, M, sampleRate);
% rxSignalCoarse = coarseCorrectionFFT(rxFiltered, M, sampleRate);

rxFiltered = upfirdn(rxSignalCoarse, rrcFilter, 1, sps);
rxFiltered = rxFiltered(span+1:end-span);

rxSignalPhaseCorr = phaseCorrection(rxSignalCoarse, preambleMod);
% rxSignalPhaseCorr = phaseCorrection(rxFiltered, preambleMod);

% Fine frequency correction
% rxSignalFine = fineCorrection(rxSignalCoarse, M, sps);
% rxSignalFine = fineCorrection(rxSignalPhaseCorr, M, sps);
rxSignalFine = fineCorrection(rxFiltered, M, sps);

% Timing correction
% rxUpsampled = upsample(rxSignalFine, 2);
% [rxTimingCorr, timingError] = timingCorrGardner(rxUpsampled, M, sps);

% rxSignalFineInterp = interp(rxSignalFine, 4);

rxFinal = rxSignalFine;

%%%------------------------------------------------------------

% scatterplot(rxSignalFine);
scatterplot(rxFinal);

eyediagram(rxFinal, 2);

%%%------------------------------------------------------------
% Demodulate

demodulatedBits = pskdemod(rxFinal, M, pi/M, "gray");
% demodulatedBits = pskdemod(rxSignalFine, M, pi/M, "gray");
% demodulatedBits = pskdemod(rxSignalCoarse, M, pi/M, "gray");

error = sum(demodulatedBits ~= bitStream);
Pb = error/(numBits+length(preamble));

%%%------------------------------------------------------------
