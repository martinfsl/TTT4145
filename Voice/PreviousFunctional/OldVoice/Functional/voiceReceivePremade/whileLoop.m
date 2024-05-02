error = 0;
while error < 500
    run receiveOnce.m
end

scatterplot(rxSignal);
scatterplot(rxFiltered);
scatterplot(rxSignalCoarse);
scatterplot(rxTimingSync);
scatterplot(rxSignalFine);
scatterplot(rxSignalPhaseCorr);
scatterplot(rxMessage);