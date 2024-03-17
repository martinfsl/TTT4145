function processBuffer()
    global buffer;
    global bufferProcessSize;

    % fprintf("%s %i %i\n", "Processed Buffer called, ", length(buffer), bufferProcessSize);

    if size(buffer, 2) >= bufferProcessSize
        disp("Buffer is larger than specified size");

        buffer = buffer(:, bufferProcessSize+1:end);

        disp("Playing sound");
        sound(buffer(:), 16000);
        disp("Played sound");
    end
end