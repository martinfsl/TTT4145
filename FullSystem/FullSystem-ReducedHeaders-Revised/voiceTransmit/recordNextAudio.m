function recordNextAudio(audioInput, frameSize)
    
    global voiceMessages

    % fprintf("%s %i, \n", "Recording bulk: ", size(voiceMessages, 2)-1);

    audioData = audioInput();

    processedData = audioDataToSymbols(audioData);
    voiceMessage = reshape(processedData, frameSize, []);

    voiceMessages = [voiceMessages, voiceMessage];

    % fprintf("%s %i \n", "Finished recording bulk:", size(voiceMessages, 2)-2);
end