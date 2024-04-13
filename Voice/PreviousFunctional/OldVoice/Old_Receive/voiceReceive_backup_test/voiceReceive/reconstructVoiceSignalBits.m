function voiceSignalRec = reconstructVoiceSignalBits(decodedMessage, lenMessage)
    % Assuming symbols contain values 0 through 3
    nSymbols = lenMessage;
    
    % Assuming 8 bits per sample
    nBits = 8;
    nLevels = 2^nBits;
    nSamples = nSymbols / nBits;
    y_quantized_reconstructed = zeros(nSamples, 1);
    
    for i = 1:nSamples
        startIndex = (i-1) * nBits + 1;
        endIndex = i * nBits;
        y_quantized_reconstructed(i) = bit2int(decodedMessage(startIndex:endIndex), 8);
    end
    
    % y_dequantized = (double(y_quantized_reconstructed) / ((nLevels/2) - 1)) - 1;
    voiceSignalRec = (double(y_quantized_reconstructed) / ((nLevels/2) - 1)) - 1;
end