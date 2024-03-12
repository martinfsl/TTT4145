% Transmitter
bitStream = randi([0 1], numSymbols, 1);

modulatedBits = pskmod(bitStream, 2);

span = 20; bps = log2(2); sps = 5;
delayInSamples = (span/2)*sps;

txfilter = comm.RaisedCosineTransmitFilter(...
    RolloffFactor = 0.5, ...
    FilterSpanInSymbols = span, ...
    OutputSamplesPerSymbol = sps);

shapedSignal = txfilter(modulatedBits);

fvtool(txfilter, Analysis="impulse");

% Channel
signalThroughChannel = awgn(shapedSignal, 5);



% Receiver
rxSignal = signalThroughChannel;
rxSignalAdjusted = circshift(rxSignal, [-delayInSamples, 0]);

rxSignalCompressed = [];
for i = 1:numSymbols
   k = sps*i - (sps-1)*1;
   rxSignalCompressed = [rxSignalCompressed rxSignalAdjusted(k)];
end
rxSignalCompressed = rxSignalCompressed';

rxfilterV2 = comm.RaisedCosineReceiveFilter(...
    RolloffFactor = 0.5, ...
    FilterSpanInSymbols = 2, ...
    InputSamplesPerSymbol = 1, ...
    DecimationFactor = 1);
deshapedSignal = circshift(rxfilterV2(rxSignalCompressed), [-1, 0]);

demodulatedBits = pskdemod(deshapedSignal, 2);

numError = sum(bitStream ~= demodulatedBits);
Pb = numError/numSymbols;
