dataStream = randi([0 1], 1, 100);

[bpskSignal, s1, s2] = BPSK_modulator(dataStream, t);

fRef = 1e6;
mt = bpskSignal.*exp(1j*2*pi*fRef*t);

transmitRepeat(tx, mt');