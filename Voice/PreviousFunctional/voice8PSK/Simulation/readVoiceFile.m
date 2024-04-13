voiceMessage = quantizeAudioToSymbols("../VoiceFiles/fredrikstad_11000.wav");

% partitions = 78;
% voiceMessageCut = voiceMessage(1:234000);
% 
% messages = reshape(voiceMessageCut, [length(voiceMessageCut)/partitions, partitions]);
% 
% [y, fs] = audioread("../VoiceFiles/fredrikstad_11000.wav");
% reconstructed = reconstructAudioFromSymbols(messages(:), 8, fs);
% 
