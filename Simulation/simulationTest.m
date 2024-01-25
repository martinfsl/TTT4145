numSymbols = 1000;
sampleRate = 5e9;

bitStream = randi([0 3], numSymbols, 1);

% QPSK-modulation
modulatedSignal = pskmod(bitStream, 4, pi/4);

% Bandpass modulation
fRef = 1.8e9;
t = [0:numSymbols-1]'/sampleRate;
transmittedSignal = modulatedSignal .* exp(1j*2*pi*fRef*t);

receivedSignal = awgn(modulatedSignal, 20) .* exp((-1)*1j*2*pi*fRef*t);

demodulatedSignal = pskdemod(receivedSignal, 4, pi/4);