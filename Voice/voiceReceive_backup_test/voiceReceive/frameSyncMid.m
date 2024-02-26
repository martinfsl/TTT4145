function [frameSynced, rxMessage, rxPreamble, rxHeader] = ...
    frameSyncMid(rxSignal, frameStart, preamble, frameSize, header)

    rxPreamble = rxSignal(frameStart:frameStart+length(preamble)-1);

    rxMessageFirstHalf = rxSignal(frameStart-frameSize:frameStart-1);
    rxMessageSecondHalf = ...
        rxSignal(frameStart+length(preamble)+length(header):...
                 frameStart+length(preamble)+length(header)+frameSize-1);
    rxMessage = [rxMessageFirstHalf; rxMessageSecondHalf];

    rxHeader = rxSignal(frameStart+length(preamble):...
                        frameStart+length(preamble)+length(header)-1);

    frameSynced = rxSignal;
end