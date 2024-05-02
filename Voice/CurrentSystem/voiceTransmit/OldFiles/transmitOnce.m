run setupTxSignal.m

release(tx);

rng(100);
junk = randi([0 M-1], length(bitStream), 1);
junkMod = pskmod(junk, M, pi/M, "gray");

% transmitRepeat(tx, upfirdn(junkMod, rrcFilter, sps, 1));
% pause(5);
% transmitRepeat(tx, txSignal);
% pause(0.15);
% transmitRepeat(tx, upfirdn(junkMod, rrcFilter, sps, 1));
% pause(1);
% release(tx);

tx(txSignal);