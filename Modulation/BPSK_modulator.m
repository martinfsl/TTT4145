function [bpskSignal, s1, s2] = BPSK_modulator(sequence, t)
    % bpskSignal = zeros(size(t));
    bpskSignal = [];
    valueDuration = length(t)/length(sequence);
    
    time = 0:2*pi/valueDuration:2*pi*(1-1/valueDuration);
    
    s1 = cos(time-pi/4);
    s2 = cos(time-3*pi/4);
    
    for i = 1:length(sequence)
        if sequence(i) == 1
            bpskSignal = [bpskSignal s1];
        else
            bpskSignal = [bpskSignal s2];
        end
    end
end