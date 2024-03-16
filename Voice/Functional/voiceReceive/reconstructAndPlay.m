receivedMessages = [];
for i = 1:size(allMessages, 2)
    receivedMessages = [receivedMessages; allMessages(:, i)];
end

recVoice = reconstructVoiceSignal(receivedMessages);

sound(recVoice, 16000);