% message = messages(:, i);
% header = headers(:, i);

filler = randi([0 M-1], fillerSize*2, 1);

bitStream = [preamble; headers(:, 1); messages(:, 1); zeros(60000, 1); preamble; headers(:, 2); messages(:, 2); zeros(30000, 1)];
bitStreamMod = pskmod(bitStream, M, pi/M, "gray");

txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);

transmitRepeat(tx, txSignal);