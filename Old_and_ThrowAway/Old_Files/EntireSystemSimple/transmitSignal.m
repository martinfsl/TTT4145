run("setupParameters.m");
run("transmitterSetup.m");

rng(1); % Setting seed
bitStream = randi([0 M-1], numBits, 1); % Generating bitstream

% modulatedSignal = qammod(bitStream, M, "gray");
modulatedSignal = pskmod(bitStream, M, pi/M, "gray");

txSignal = upfirdn(modulatedSignal, rrcFilter, 8, 1);

scatterplot(modulatedSignal);

transmitRepeat(tx, txSignal);