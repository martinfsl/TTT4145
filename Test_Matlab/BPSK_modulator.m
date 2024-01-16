function bpskSignal = BPSK_modulator(sequence, t, fs, valueDuration)
    bpskSignal = zeros(size(t));

    for i = 1:length(sequence)
        startIndex = (i-1) * fs * valueDuration + 1;
        endIndex = i * fs * valueDuration;

        value = 0;
        if sequence(i) == 1
            value = 1;
        elseif sequence(i) == 0 || sequence(i) == -1
            value = -1;
        end

        time = t(1:fs*valueDuration);
        bpskSignal(startIndex:endIndex) = cos(2*pi*2*time - (pi/2)*value);
    end
end