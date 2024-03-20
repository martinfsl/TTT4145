function symbols = convertToSymbols(data)
    
    symbols = zeros(length(data)*4, 1);

    for i = 1:length(data)
        val = data(i);

        valBit = int2bit(val, 8);
        
        for j = 1:4
            bits = valBit(2*j-1 : 2*j);

            symbols((i-1)*4 + j) = bit2int(bits, 2);
        end
    end
end