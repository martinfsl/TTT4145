voiceRec = reconstructVoiceSignal(decodedMessage, length(decodedMessage));
% voiceRec = reconstructVoiceSignalBits(message, length(message));

sound(voiceRec, 16000);