i = 1;
% while (i < size(interleaving_fewErrors.allRxSignals, 2))
%     rxSignal = interleaving_fewErrors.allRxSignals(:, i+1);
while (i < 6)
    % rxSignalTemp = allRxSignals(:, i);
    rxSignal = interleaving_fewErrors.allRxSignals(:, i+1);
    run receiveOnce.m
    run connectReceivedSignals.m
    disp(i);
    i = i + 1;
end