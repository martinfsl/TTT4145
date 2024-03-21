function processBuffer()
    global allRxSignals;
    global AAOverflow;
    global rx;

    % fprintf("%s %i %i\n", "Processed Buffer called, ", length(buffer), bufferProcessSize);
    % tic
    [rxSignal, ~, AAOverflow] = rx();
    allRxSignals = [allRxSignals, rxSignal];
    disp("Read signal");
    % toc
end