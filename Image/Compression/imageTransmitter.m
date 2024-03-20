% ------------------------------------
% Compress the image
original = imread('Lena/Lena.png');

compressedImageFile = 'Lena/LenaCompressed.jpg';
compressionQuality = 25;
% compressionQuality = 20;

imwrite(original, compressedImageFile, 'jpg', 'Quality', compressionQuality);
% ------------------------------------
% ------------------------------------
% Divinding into chunks
fileID = fopen('Lena/LenaCompressed.jpg', 'rb');

% Finding a compatible chunk size
compressedData_total = fread(fileID, 'uint8');
chunkSize = length(compressedData_total)/5;
fclose(fileID);

fileID = fopen('Lena/LenaCompressed.jpg', 'rb');
chunks = [];
chunksSymbols = [];
while ~feof(fileID)
    chunkData = fread(fileID, chunkSize, 'uint8');

    if isempty(chunkData)
        break
    end

    chunkDataSymbols = convertToSymbols(chunkData);

    chunks = [chunks, chunkData];
    chunksSymbols = [chunksSymbols, chunkDataSymbols];
end
fclose(fileID);
% ------------------------------------
