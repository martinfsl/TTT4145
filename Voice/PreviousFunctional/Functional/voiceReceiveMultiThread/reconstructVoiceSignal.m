function voiceSignalRec = reconstructVoiceSignal(symbols)
    % Assuming symbols contain values 0 through 3
    nSymbols = length(symbols);
    bitPairs = zeros(nSymbols, 2);
    
    for i = 1:nSymbols
        switch symbols(i)
            case 0
                bitPairs(i, :) = [0, 0];
            case 1
                bitPairs(i, :) = [0, 1];
            case 2
                bitPairs(i, :) = [1, 0];
            case 3
                bitPairs(i, :) = [1, 1];
        end
    end
    
    % Flatten bitPairs to a bit vector
    y_bits_reconstructed = uint8(reshape(bitPairs.', [], 1));
    
    % Assuming 8 bits per sample
    nBits = 8;
    nLevels = 2^nBits;
    nSamples = floor(nSymbols*2 / nBits);
    y_quantized_reconstructed = zeros(nSamples, 1);
    
    for i = 1:nSamples
        startIndex = (i-1) * nBits + 1;
        endIndex = i * nBits;
        y_quantized_reconstructed(i) = bit2int(y_bits_reconstructed(startIndex:endIndex), 8);
    end
    
    % y_dequantized = (double(y_quantized_reconstructed) / ((nLevels/2) - 1)) - 1;
    voiceSignalRec = (double(y_quantized_reconstructed) / ((nLevels/2) - 1)) - 1;
end