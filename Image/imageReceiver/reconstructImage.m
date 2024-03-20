function decompressedImage = reconstructImage(data)
    reconstructedFile = 'CompressedImages/reconstructedImage.jpg';
    
    fileID = fopen(reconstructedFile, 'wb');
    
    receivedChunks = data;
    
    for i = 1:size(receivedChunks, 2)
        chunkDataReceived = convertToInt(receivedChunks(:, i));
    
        fwrite(fileID, chunkDataReceived, 'uint8');
    end
    
    fclose(fileID);
    
    decompressedImage = imread(reconstructedFile);
    
    % imshow(decompressedImage, []);
end
