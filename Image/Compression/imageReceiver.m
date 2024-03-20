reconstructedFile = 'Lena/reconstructedImage.jpg';

fileID = fopen(reconstructedFile, 'wb');

receivedChunks = chunksSymbols;

for i = 1:size(receivedChunks, 2)
    chunkDataReceived = convertToInt(receivedChunks(:, i));

    fwrite(fileID, chunkDataReceived, 'uint8');
end

fclose(fileID);

decompressedImage = imread(reconstructedFile);

imshow(decompressedImage, []);
