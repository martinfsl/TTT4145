% This is used to make the transmitter play some junk first to stabilize
% the signal

release(tx);

rng(100);
junk = randi([0 M-1], length(bitStream), 1);
junkMod = pskmod(junk, M, pi/M, "gray");

transmitRepeat(tx, upfirdn(junkMod, rrcFilter, sps, 1));