function voiceMessage = processVoice(y)
    y_scaled = ((y+1)/2)*255;
    
    nBits = 8;
    nLevels = 2^nBits;  % Number of quantization levels
    y_quantized = uint8(round(y_scaled));
    
    y_bits = int2bit(y_quantized, nBits);
    
    nSymbols = length(y_bits)/2;
    voiceMessage = zeros(nSymbols, 1);
    
    for i = 1:nSymbols
        bits = y_bits((i-1)*2 + 1 : i*2);
        voiceMessage(i) = bit2int(bits, 2);
    end
end