% dataStream = randi([0 1], 1, 100);
dataStream = ones(1, numSymbols);

[bpskSignal, s1, s2] = BPSK_modulator(dataStream, t);

fRef = 500e3;
mt = bpskSignal.*exp(1j*2*pi*fRef*t);
% mt = bpskSignal.*exp(1j*2*pi*(-fRef)*t);
% mt = bpskSignal.*(1+1j);

transmitRepeat(tx, mt');