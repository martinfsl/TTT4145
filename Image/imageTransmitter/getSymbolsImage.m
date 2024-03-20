function imageSymbols = getSymbolsImage(Quality, Partitions, inputFile, FolderName)
    % ------------------------------------
    % Compress the image
    % original = imread('Lena/Lena.png');
    original = imread(inputFile);

    % compressedImageFile = 'Lena/LenaCompressed.jpg';
    compressedImageFile = strcat(FolderName, '/', FolderName, 'Compressed.jpg');
    
    % compressionQuality = 25;
    % compressionQuality = 10;
    compressionQuality = Quality;
    
    imwrite(original, compressedImageFile, 'jpg', 'Quality', compressionQuality);
    % ------------------------------------
    % ------------------------------------
    % Divinding into chunks
    fileID = fopen(compressedImageFile, 'rb');
    
    % Finding a compatible chunk size
    compressedData_total = fread(fileID, 'uint8');

    disp(length(compressedData_total));

    chunkSize = length(compressedData_total)/Partitions;
    fclose(fileID);
    
    fileID = fopen(compressedImageFile, 'rb');
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

    imageSymbols = chunksSymbols;
end