dataStream = ones(numSymbols, 1);
% dataStream = randi([0 3], numSymbols, 1);

dataModulated = pskmod(dataStream, 4, pi/4);

fRef = 100e3;
mt = dataStream'.*exp(1j*2*pi*fRef*t);

% transmitRepeat(tx, dataModulated);
transmitRepeat(tx, mt');