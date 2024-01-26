% Set-up
close all;
run("Setup/setupParameters.m");

% Transmitter

bitStream = randi([0 7], numBits, 1);
M = 8;
% bitStream = randi([0 7], numBits, 1);
% M = 8;

% modulatedSignal = pskmod(bitStream, M, pi/M, "gray");
modulatedSignal = qammod(bitStream, M, "gray");

rolloff = 0.8; span = 20; sps = 5; k = log2(M);

rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");
txSignal = upfirdn(modulatedSignal, rrcFilter, sps);



% Channel
% White Gaussian
SignalThroughChannel = awgn(txSignal, 15);
pfo = comm.PhaseFrequencyOffset("PhaseOffset", 0, "FrequencyOffset", 0, ...
    "SampleRate", sampleRate);
SignalThroughChannel = step(pfo, SignalThroughChannel);

% Rician Channel
% ricianchan = comm.RicianChannel( ...
%     'SampleRate',1e6, ...
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


% Receiver
rxSignal = SignalThroughChannel;

rxFiltered = upfirdn(rxSignal, rrcFilter, 1, sps);
rxFiltered = rxFiltered(span+1:end-span);

% demodulatedBits = pskdemod(rxFiltered, M, pi/M, "gray");
demodulatedBits = qamdemod(rxFiltered, M, "gray");

numError = sum(bitStream ~= demodulatedBits);
Pb = numError/numBits;

scatterplot(modulatedSignal);
scatterplot(rxFiltered);

% Nfft = length(txSignal);
% f = linspace(-0.5, 0.5, Nfft+1); f(end) = [];
% f = sampleRate.*f;
% spectrumTx = 10*log10(fftshift(fft(txSignal, Nfft)));
% spectrumRx = 10*log10(fftshift(fft(rxSignal, Nfft)));
% 
% figure(1);
% hold on;
% plot(f, spectrumTx);
% plot(f, spectrumRx);
% legend("Tx", "Rx");
% hold off;

% eyediagram(modulatedSignal, 6);
% eyediagram(txSignal, 6);
% eyediagram(rxFiltered, 6);


