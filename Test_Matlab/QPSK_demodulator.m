function [detectedSignal, error] = QPSK_demodulator(signalFiltered, sequence, t, fs, valueDuration)
    time = t(1:2*fs*valueDuration);
    bit_per_symbol = 2;
    
    f_11 = cos(2*pi*2*time + (1/4)*pi);
    f_01 = cos(2*pi*2*time + (3/4)*pi);
    f_00 = cos(2*pi*2*time + (5/4)*pi);
    f_10 = cos(2*pi*2*time + (7/4)*pi);

    detectedSequence = zeros(size(sequence));
    LUT = [[1, 1], [0, 1], [0, 0], [1, 0]];
    error = 0;
    
    for i = 1:(length(sequence)/bit_per_symbol)
       startIndex = (i-1)*length(time)+1; endIndex = i*length(time);

       segment_num_i = signalFiltered(startIndex:endIndex);

       corr_11 = corrcoef(segment_num_i, f_11);
       corr_01 = corrcoef(segment_num_i, f_01);
       corr_00 = corrcoef(segment_num_i, f_00);
       corr_10 = corrcoef(segment_num_i, f_10);
       
       correlations = [corr_11(1, 2), corr_01(1, 2), corr_00(1, 2), corr_10(1, 2)];
       
       [~, I] = max(correlations);
       
       detectedSequence(2*i-1:2*i) = LUT(2*I-1:2*I);
    end
    
    
    for i = 1:length(sequence)
        if sequence(i) ~= detectedSequence(i)
            error = error + 1;
        end
    end

    detectedSignal = GetSquareWave(detectedSequence, size(t), fs, valueDuration);
end
