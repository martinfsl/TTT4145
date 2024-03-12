% voiceRec = reconstructVoiceSignal(decodedMessage, length(decodedMessage));
% voiceRec = reconstructVoiceSignal(voiceMessage, length(voiceMessage));
voiceRec = reconstructVoiceSignal(voiceMessageDeinterleaved, length(voiceMessage));

sound(voiceRec, 16000);