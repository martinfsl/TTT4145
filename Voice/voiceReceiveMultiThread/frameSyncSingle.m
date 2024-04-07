function [foundHeaders, foundMessages] = ...
    frameSyncSingle(rxSignal, idx, frameSize, headerSize, M)

    foundHeaders = [];
    foundMessages = [];
    for i = 1:length(idx)
        if idx(i) < length(rxSignal)-frameSize-20
            decodedHeader = pskdemod(...
                rxSignal(idx(i)+1:idx(i)+1+headerSize-1), ...
                M, pi/M, "gray");
            foundHeaders = [foundHeaders, decodedHeader];
    
            decodedMessage = pskdemod(...
                rxSignal(idx(i)+1+headerSize:idx(i)+1+headerSize+frameSize-1), ...
                M, pi/M, "gray");
            foundMessages = [foundMessages, decodedMessage];
    end
end