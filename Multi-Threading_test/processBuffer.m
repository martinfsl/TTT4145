function processBuffer()
    global buffer;
    global bufferProcessSize;

    disp("Process Buffer called");
    % fprintf("%s %i %i\n", "Processed Buffer called, ", length(buffer), bufferProcessSize);

    if length(buffer) >= bufferProcessSize
        disp("Buffer is larger than specified size");
        processedData = buffer(1:bufferProcessSize);

        buffer = buffer(bufferProcessSize+1:end);
    end
end