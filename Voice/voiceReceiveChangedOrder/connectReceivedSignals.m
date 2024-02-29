h = 4*mode(decodedHeader(1:3)) + 1*mode(decodedHeader(4:6));

allRxSignals = [allRxSignals, rxSignal];
allRxMessages = [allRxMessages, rxMessage];
allDecodedMessages = [allDecodedMessages, decodedMessage];
allReceivedHeaders = [allReceivedHeaders, h];