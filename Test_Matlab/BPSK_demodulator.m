function [detectedSignal, error] = BPSK_demodulator(signalFiltered, sequence, t, fs, valueDuration)
    time = t(1:fs*valueDuration);
    i_phase = cos(2*pi*2*time - (pi/2));
    q_phase = cos(2*pi*2*time + (pi/2));

    detectedSequence = zeros(size(sequence));
    error = 0;
    
    for i = 1:length(sequence)
       startIndex = (i-1) * fs * valueDuration + 1;
       endIndex = i * fs * valueDuration;

       segment_num_i = signalFiltered(startIndex:endIndex);

       corr_i = corrcoef(segment_num_i, i_phase);
       corr_q = corrcoef(segment_num_i, q_phase);

       if corr_i(1, 2) >= corr_q(1, 2)
           detectedSequence(i) = 1;
       elseif corr_i(1, 2) < corr_q(1, 2)
           detectedSequence(i) = 0;
       end
    end
    
    for i = 1:length(sequence)
        if sequence(i) ~= detectedSequence(i)
            error = error + 1;
        end
    end

    detectedSignal = GetSquareWave(detectedSequence, size(t), fs, valueDuration);
end
