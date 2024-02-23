voiceMessage = [];

[organizedHeaders, sortIdx] = sort(allReceivedHeaders, "ascend");

for i = 1:length(sortIdx)
    voiceMessage = [voiceMessage; allDecodedMessages(:, sortIdx(i))];
end

% voiceRec = reconstructVoiceSignal(decodedMessage, length(decodedMessage));
voiceRec = reconstructVoiceSignal(voiceMessage, length(voiceMessage));

sound(voiceRec, 16000);