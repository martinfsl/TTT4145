% ------------------------------------
% Compress the image
original = imread('Lena.png');

compressedImageFile = 'LenaCompressed.jpg';
compressionQuality = 25;

imwrite(original, compressedImageFile, 'jpg', 'Quality', compressionQuality);
% ------------------------------------
% ------------------------------------
% Divinding into chunks
fileID = fopen('LenaCompressed.jpg', 'rb');

% Finding a compatible chunk size
compressedData_total = fread(fileID, 'uint8');
chunkSize = length(compressedData_total)/5;
fclose(fileID);

fileID = fopen('LenaCompressed.jpg', 'rb');
chunkCounter = 1;
chunks = [];
while ~feof(fileID)
    chunkData = fread(fileID, chunkSize, 'uint8');
    chunks = [chunks, chunkData];
    chunkCounter = chunkCounter + 1;
end
fclose(fileID);
% ------------------------------------
% ------------------------------------
% Read the image back
reconstructedFile = 'reconstructedImage.jpg';

fileID = fopen(reconstructedFile, 'wb');

receivedChunks = chunks;

for i = 1:size(receivedChunks, 2)
    fwrite(fileID, receivedChunks(:, i), 'uint8');
end

fclose(fileID);

decompressedImage = imread(reconstructedFile);

imshow(decompressedImage, []);
% ------------------------------------