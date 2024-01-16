clear all; close all;

% sequence = [1 1 -1 1 -1 -1 -1 1 1 -1 1];
sequence = [1 1 0 1 0 0 0 1 0 1];
valueDuration = 0.5;

fs = 1000;

t = 0:1/fs:(length(sequence)*valueDuration-1/fs);

squareWaveSignal = GetSquareWave(sequence, size(t), fs, valueDuration);
bpskSignal = BPSK_modulator(sequence, t, fs, valueDuration);

channelCode = [0 1 0 1 0 1 0 1 0 1];
channelCode = BPSK_modulator(channelCode, t, fs, valueDuration);

bpskSignalEncoded = bpskSignal.*channelCode;

fc = 100;    
carrierSignal = cos(2*pi*fc*t);

bandpassSignal = Bandpass_modulator(bpskSignalEncoded, carrierSignal, 5);
basebandSignal = Bandpass_demodulator(bandpassSignal, carrierSignal, 0.05, 0.2);
basebandSignalDecoded = basebandSignal.*channelCode;
[detectedSignal, error] = BPSK_demodulator(basebandSignalDecoded, sequence, t, fs, valueDuration);

% figure(1);
% hold on;
% % plot(t, bandpassSignal);
% plot(t, squareWaveSignal);
% plot(t, bpskSignal);
% plot(t, detectedSignal);
% axis([0 length(sequence)*valueDuration -1.5 1.5]); % Adjust axis for better visualization
% hold off;

% Nfft = length(carrierSignal);
% f = linspace(-0.5, 0.5, Nfft+1); f(end) = [];
% signal_bb = 10*log10(fftshift(fft(basebandSignal, Nfft)));
% signal_bp = 10*log10(fftshift(fft(bandpassSignal, Nfft)));
% 
% figure(2);
% plot(f, signal_bb);
% 
% figure(3);
% plot(f, signal_bp);