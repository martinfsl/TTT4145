% Run setupTransmitter before running this script
% run setupTransmitter.m;
run setupTxSignal.m
transmitRepeat(tx, txSignal);
% tx(txSignal);