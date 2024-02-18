[y, Fs] = audioread("stry(1).wav");

nBits = 8;
nLevels = 2^nBits;  % Number of quantization levels
y_quantized = uint8(round((y + 1) * (nLevels/2 - 1)));

y_bits = int2bit(y_quantized, nBits);

nSymbols = length(y_bits)/2;
symbols = zeros(nSymbols, 1);

for i = 1:nSymbols
    bits = y_bits((i-1)*2 + 1 : i*2);
    symbols(i) = bit2int(bits, 2);
end