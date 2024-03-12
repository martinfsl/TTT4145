% Set up parameters and signals
sampleRate = 5e6;
centerFreq = 1.8e9;
numSamples = 1024*1024;

% numBits = 1e6;
numBits = 10e3;
samplesPerSymbol = 10;
timeSize = numBits*samplesPerSymbol;

modulation = 'qpsk';
M = 4;
rolloff = 0.5; span = 20; sps = 5;

rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");

% t = [0:numBits-1]/sampleRate;