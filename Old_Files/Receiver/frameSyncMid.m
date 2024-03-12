function [frameSynced, rxMessage, rxPreamble] = frameSyncMid(rxSignal, frameStart, ...
    preamble, frameSize)

    rxPreamble = rxSignal(frameStart:frameStart+length(preamble)-1);

    rxMessageFirstHalf = rxSignal(frameStart-frameSize:frameStart-1);
    rxMessageSecondHalf = ...
        rxSignal(frameStart+length(preamble):frameStart+length(preamble)+frameSize-1);
    rxMessage = [rxMessageFirstHalf; rxMessageSecondHalf];

    frameSynced = rxSignal;
end