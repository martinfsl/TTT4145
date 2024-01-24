% Set up parameters and signals
sampleRate = 1e6;
centerFreq = 2.4e9;
numSamples = 1024*1024;

numSymbols = 1000;
samplesPerSymbol = 10;
timeSize = numSymbols*samplesPerSymbol;

t = [0:numSymbols-1]/sampleRate;