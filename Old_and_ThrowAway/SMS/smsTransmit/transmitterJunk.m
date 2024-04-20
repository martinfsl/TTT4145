% This is used to make the transmitter play some junk first to stabilize
% the signal

release(tx);

rng(100);
junk = randi([0 M-1], length(preamble) + size(headers, 1) + frameSize + 2*fillerSize, 1);
junkMod = pskmod(junk, M, pi/M, "gray");

transmitRepeat(tx, upfirdn(junkMod, rrcFilter, sps, 1));