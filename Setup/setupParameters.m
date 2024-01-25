% Set up parameters and signals
sampleRate = 5e6;
centerFreq = 1.8e9;
numSamples = 1024*1024;

numSymbols = 1000;
samplesPerSymbol = 10;
timeSize = numSymbols*samplesPerSymbol;

t = [0:numSymbols-1]/sampleRate;