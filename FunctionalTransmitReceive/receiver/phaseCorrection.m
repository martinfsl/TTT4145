function phaseCorr = phaseCorrection(rxSignal, preamble, frameStartIndex, prevRxSignal)

    if frameStartIndex <= 0
        receivedPreamble = prevRxSignal(end+frameStartIndex+1:end);
        receivedPreamble = [receivedPreamble; ...
                            rxSignal(1:length(preamble)+frameStartIndex)];
    else
        receivedPreamble = rxSignal(...
            frameStartIndex:(frameStartIndex + length(preamble) - 1));
    end

    % disp(size(receivedPreamble));
    phaseDiff = angle(mean(conj(preamble) .* receivedPreamble));

    % disp(phaseDiff*(360/(2*pi)));

    phaseCorr = rxSignal * exp(-1i * phaseDiff);

    % scatterplot(receivedPreamble);
end