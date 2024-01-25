% dataStream = ones(numSymbols, 1);
% dataStream = randi([0 3], numSymbols, 1);

% dataModulated = pskmod(dataStream, 4, pi/4);

% fRef = 1e6;
% mt = dataStream'.*exp(1j*2*pi*fRef*t);
% mt = dataModulated'.*exp(1j*2*pi*fRef*t);

% transmitRepeat(tx, dataModulated);
% transmitRepeat(tx, mt');

dataStream = randi([0 1], numSymbols, 1);

qpskModulator = comm.QPSKModulator('BitInput', true);
qpskSymbols = qpskModulator(dataStream);

rrcFilter = comm.RaisedCosineTransmitFilter('RolloffFactor',0.3);
shapedSymbols = rrcFilter(qpskSymbols);


