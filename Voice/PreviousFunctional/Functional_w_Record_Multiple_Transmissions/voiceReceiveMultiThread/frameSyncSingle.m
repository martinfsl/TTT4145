function [foundBulkHeaders, foundHeaders, foundMessages, rxMessage] = ...
    frameSyncSingle(rxSignal, idx, frameSize, bulkHeaderSize, headerSize, M)

    foundBulkHeaders = [];
    foundHeaders = [];
    foundMessages = [];
    for i = 1:length(idx)
        if idx(i) < length(rxSignal)-frameSize-20
            decodedBulkHeader = pskdemod(...
                rxSignal(idx(i)+1:idx(i)+1+bulkHeaderSize-1), ...
                M, pi/M, "gray");
            foundBulkHeaders = [foundBulkHeaders, decodedBulkHeader];

            decodedHeader = pskdemod(...
                rxSignal(idx(i)+1:idx(i)+1+bulkHeaderSize+headerSize-1), ...
                M, pi/M, "gray");
            foundHeaders = [foundHeaders, decodedHeader];
    
            % scatterplot(rxSignal(idx(i)+1:idx(i)+1+headerSize-1));

            decodedMessage = pskdemod(...
                rxSignal(idx(i)+1+headerSize:...
                         idx(i)+1+bulkHeaderSize+headerSize+frameSize-1), ...
                M, pi/M, "gray");
            foundMessages = [foundMessages, decodedMessage];

            rxMessage = rxSignal(idx(i)+1+bulkHeaderSize+headerSize:...
                                 idx(i)+1+bulkHeaderSize+headerSize+frameSize-1);
            % scatterplot(rxSignal(idx(i)+1+headerSize:idx(i)+1+headerSize+frameSize-1));
        end
    end
end