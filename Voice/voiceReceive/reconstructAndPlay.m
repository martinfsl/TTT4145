% receivedMessages = [];
% for i = 1:size(allMessages, 2)
%     receivedMessages = [receivedMessages; allMessages(:, i)];
% end

voiceMessagesCut = voiceMessages(:, 1:64);
recVoice = reconstructVoiceSignal(voiceMessagesCut(:));

sound(recVoice, 16000);