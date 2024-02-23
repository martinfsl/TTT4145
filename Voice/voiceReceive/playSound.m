% voiceRec = reconstructVoiceSignal(decodedMessage, length(decodedMessage));
voiceRec = reconstructVoiceSignal(connectedSignal, length(connectedSignal));

sound(voiceRec, 16000);