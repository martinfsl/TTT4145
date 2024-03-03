load ../Measurements_0103/ninthSweep.mat

i = 0;
while (i < size(interleaving_fewErrors.allRxSignals, 2))
    rxSignal = interleaving_fewErrors.allRxSignals(:, i+1);
    run receiveOnce.m
    run connectReceivedSignals.m
    disp(i);
    i = i + 1;
end