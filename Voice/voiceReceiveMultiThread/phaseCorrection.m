function [phaseCorr, phaseDiff] = phaseCorrection(rxSignal, preamble, receivedPreamble)

    % disp(size(receivedPreamble));
    phaseDiff = angle(mean(conj(preamble) .* receivedPreamble));

    % disp(phaseDiff*(360/(2*pi)));

    % fprintf("%s %i \n", "Estimated angle: ", phaseDiff*(360/(2*pi)))

    phaseCorr = rxSignal * exp(-1i * phaseDiff);

    % scatterplot(receivedPreamble);
end