clear all; close all;

sequence = [1 1 0 1 0 0 0 1 1 1 0 1];
valueDuration = 0.5;

fs = 1000;

t = 0:1/fs:(length(sequence)*valueDuration-1/fs);

squareWaveSignal = GetSquareWave(sequence, size(t), fs, valueDuration);
qpskSignal = QPSK_modulator(sequence, t, fs, valueDuration);

fc = 100;
carrierSignal = cos(2*pi*fc*t);

bandpassSignal = Bandpass_modulator(qpskSignal, carrierSignal, 1000);
basebandSignal = Bandpass_demodulator(bandpassSignal, carrierSignal, 0.05, 0.2);
[detectedSignal, error] = QPSK_demodulator(basebandSignal, sequence, t, fs, valueDuration);

% Nfft = length(qpskSignal);
% f = linspace(-0.5, 0.5, Nfft+1); f(end) = [];
% signal_qpskSignal = 10*log10(fftshift(fft(qpskSignal, Nfft)));

% figure(1);
% hold on;
% plot(t, squareWaveSignal);
% plot(t, qpskSignal);
% plot(t, bandpassSignal);
% plot(t, basebandSignal);
% plot(t, detectedSignal);
% axis([0 length(sequence)*valueDuration -1.5 1.5]); % Adjust axis for better visualization
% hold off;

