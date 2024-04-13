function playNextAudioChunk()
    global buffer
    global bufferSize
    global bufferLowerLimit
    global deviceWriter

    % disp("Play next audio chunk");

    % tic
    if size(buffer, 2) >= bufferLowerLimit
        audioToPlay = [];
        for i = 1:bufferSize
            audioToPlay = [audioToPlay; buffer(:, i)];
        end
        deviceWriter(reconstructVoiceSignal(audioToPlay));
        
        buffer = buffer(:, bufferSize+1:end);
    end
    % toc
end