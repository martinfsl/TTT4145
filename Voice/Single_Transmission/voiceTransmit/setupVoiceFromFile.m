function [voiceMessage, Fs] = setupVoiceFromFile(file)
    [y, Fs] = audioread(file);

    if mod(length(y), 2)
        y = y(1:end-1);
    end
    
    nBits = 8;
    nLevels = 2^nBits;  % Number of quantization levels
    y_quantized = uint8(round((y + 1) * (nLevels/2 - 1)));
    
    y_bits = int2bit(y_quantized, nBits);
    
    nSymbols = length(y_bits)/2;
    voiceMessage = zeros(nSymbols, 1);

    for i = 1:nSymbols
        bits = y_bits((i-1)*2 + 1 : i*2);

        if size(bits, 1) == 1
            voiceMessage(i) = bit2int(bits', 2);
        else
            voiceMessage(i) = bit2int(bits, 2);
        end
    end
end