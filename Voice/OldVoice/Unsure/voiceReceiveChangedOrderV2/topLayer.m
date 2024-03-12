allDecodedMessages = []

i = 0;

while i < 1000
    run receiveOnceV2.m
    allDecodedMessages = [allDecodedMessages; decodedMessage];
    i = i+1;
end

error_total = symerr(allDecodedMessages, repmat([3; 2; 1; 0], 250000, 1));