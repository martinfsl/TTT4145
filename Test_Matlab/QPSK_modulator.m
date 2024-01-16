function qpskSignal = QPSK_modulator(sequence, t, fs, valueDuration)
    qpskSignal = zeros(size(t));

    bit_per_symbol = 2;
    time = t(1:2*fs*valueDuration);
    
    f_11 = cos(2*pi*2*time + (1/4)*pi);
    f_01 = cos(2*pi*2*time + (3/4)*pi);
    f_00 = cos(2*pi*2*time + (5/4)*pi);
    f_10 = cos(2*pi*2*time + (7/4)*pi);
    
    for i = 1:(length(sequence)/bit_per_symbol)
        startIndex = (i-1)*length(time)+1; endIndex = i*length(time);
        value = sequence(2*(i-1) + 1:2*i);
        
%         fprintf('%i %i\n', length(f_11), length(qpskSignal(startIndex:endIndex)));
        
        if value == [1, 1]
            qpskSignal(startIndex:endIndex) = f_11;
        elseif value == [0, 1]
            qpskSignal(startIndex:endIndex) = f_01;
        elseif value == [0, 0]
            qpskSignal(startIndex:endIndex) = f_00;
        elseif value == [1, 0]
            qpskSignal(startIndex:endIndex) = f_10;
        end
    end
end