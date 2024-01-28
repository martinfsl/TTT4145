% Set up parameters and signals
sampleRate = 5e6;
centerFreq = 1.8e9;
numSamples = 1024*1024;

numBits = 1e6;
samplesPerSymbol = 10;
timeSize = numBits*samplesPerSymbol;

t = [0:numBits-1]/sampleRate;