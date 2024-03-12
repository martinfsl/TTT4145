allDecodedMessages = [];

i = 0;

while i < 100
    run receiveOnce.m
    allDecodedMessages = [allDecodedMessages; decodedMessage];
    i = i+1;
    disp(i);
end

fulltrueMessage = repmat(trueMessage, 100, 1);
error_total = symerr(allDecodedMessages, fulltrueMessage);
error_pb = error_total/length(allDecodedMessages);