% This is used to make the transmitter play some junk first to stabilize
% the signal

release(tx);

junkSize = 29305;

rng(526);
junk = randi([0 M-1], junkSize, 1);
junkMod = pskmod(junk, M, pi/M, "gray");

transmitRepeat(tx, upfirdn(junkMod, rrcFilter, sps, 1));

disp("Transmitting junk");