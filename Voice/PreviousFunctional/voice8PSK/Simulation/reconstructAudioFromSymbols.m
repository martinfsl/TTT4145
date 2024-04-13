function y_reconstructed = reconstructAudioFromSymbols(symbols, nBits, Fs)
    % Convert symbols back to bits
    bits = de2bi(symbols, 3, 'left-msb');
    
    % Flatten the bits back into a single column
    bitsFlattened = reshape(bits', [], 1);
    
    % Since each original audio sample was represented by 8 bits, we need
    % to pad zeros to make up for the lost bits (only 3 bits were used per symbol)
    % This simplistic approach will degrade audio quality but is necessary for the simple inverse operation
    paddingBits = repmat([0, 0, 0, 0, 0]', ceil(length(bitsFlattened)/8), 1);
    bitsWithPadding = [paddingBits(1:length(bitsFlattened)), bitsFlattened];
    
    % Now, reshape these bits back into groups of 8 to form bytes
    bytes = bi2de(reshape(bitsWithPadding', 8, [])', 'left-msb');
    
    % Dequantize the bytes back to the -1 to 1 range
    y_reconstructed = double(bytes) / 255 * 2 - 1;
    
    % OPTIONAL: Play the reconstructed audio
    % sound(y_reconstructed, Fs);
end
