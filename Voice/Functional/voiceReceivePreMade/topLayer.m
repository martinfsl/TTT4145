allDecodedMessages = [];

i = 0;

while i < 1000
    run receiveOncePD.m
    allDecodedMessages = [allDecodedMessages; decodedMessage];
    i = i+1;
    disp(i);
end

fulltrueMessage = repmat(trueMessage, 1000, 1);
error_total = symerr(allDecodedMessages, fulltrueMessage);