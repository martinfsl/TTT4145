function freqEst = fineCorrection(...
    rxSignal, M, sampleRate)

    % phaseError = sign(real(rxSignal)).*imag(rxSignal) - ...
    %     sign(imag(rxSignal)).*real(rxSignal);

    loopBandwidth = 0.01;
    dampingFactor = 1;
    Kp = 2*dampingFactor*loopBandwidth; % Proportional gain
    Ki = loopBandwidth^2; % Integral gain

    phaseEstimate = 0;
    frequencyEstimate = 0;
    integrator = 0;
    phaseCorrectedSignal = zeros(length(rxSignal), 1);

    for i = 1:length(rxSignal)
        % Phase detector
        errorSignal = sign(real(rxSignal(i))).*imag(rxSignal(i)) - ...
            sign(imag(rxSignal(i))).*real(rxSignal(i));

    end
end