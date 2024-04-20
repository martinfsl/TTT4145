function reconstructedValues = convertToInt(data)

    reconstructedValues = zeros(length(data) / 4, 1);

    for i = 1:length(reconstructedValues)
        symbolGroup = data((i-1)*4+1 : i*4);
        bitValues = int2bit(symbolGroup, 2);
        reconstructedValues(i) = bit2int(bitValues, 8);
    end
end