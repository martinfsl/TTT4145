function [voiceMessage, Fs, y] = setupVoiceFromFileBits(file)
    [y, Fs] = audioread(file);
    
    nBits = 8;
    nLevels = 2^nBits;  % Number of quantization levels
    y_quantized = uint8(round((y + 1) * (nLevels/2 - 1)));
    
    voiceMessage = int2bit(y_quantized, nBits);
end