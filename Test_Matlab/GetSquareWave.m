function squarewave = GetSquareWave(sequence, l, fs, valueDuration)
    squarewave = zeros(l);
    for i = 1:length(sequence)
        startIndex = (i-1) * fs * valueDuration + 1;
        endIndex = i * fs * valueDuration;
        
        value = 0;
        if sequence(i) == 1
            value = 1;
        elseif sequence(i) == 0 || sequence(i) == -1
            value = -1;
        end
        
        squarewave(startIndex:endIndex) = value;
    end
end