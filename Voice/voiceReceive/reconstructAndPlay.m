% receivedMessages = [];
% for i = 1:(2*size(allMessages, 2)-2)
%     receivedMessages = [receivedMessages; allMessages(:, i)];
% end

recVoice = reconstructVoiceSignal(allMessages(:));

sound(recVoice, 16000);