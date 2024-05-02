function rxPackets = extractHeadersMessages(idx, rxSignal, ...
                frameSize, headerSize, preambleSize)

    rxPackets = [];

    for i = 1:length(idx)
        if idx(i) < length(rxSignal)-frameSize-20
            rxPackets = [rxPackets, ...
                rxSignal(idx(i)-preambleSize+1:idx(i)+headerSize+frameSize)];
        end
    end
end