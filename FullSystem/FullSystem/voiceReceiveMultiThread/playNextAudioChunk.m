function playNextAudioChunk()
    global buffer
    global bufferSize
    global deviceWriter

    % disp("Play next audio chunk");

    if size(buffer, 2) >= bufferSize
        audioToPlay = [];
        for i = 1:bufferSize
            audioToPlay = [audioToPlay; buffer(:, i)];
        end
        deviceWriter(reconstructVoiceSignal(audioToPlay));
        
        buffer = buffer(:, bufferSize+1:end);
    end
end