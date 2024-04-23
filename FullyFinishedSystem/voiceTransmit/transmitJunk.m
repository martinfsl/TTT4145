junkSize = amountOfFrames * (frameSize + length(preamble) + ...
                             size(bulk_headers, 1) + size(headers, 1));

rng(9982);
junk = randi([0 M-1], junkSize, 1);

global junkMod
junkMod = pskmod(junk, M, pi/M, "gray");

transmitRepeat(tx, upfirdn(junkMod, rrcFilter, sps, 1));

disp("Transmitting junk");