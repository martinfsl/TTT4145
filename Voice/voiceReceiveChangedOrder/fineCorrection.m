function fineCorrSignal = fineCorrection(...
    rxSignal, M, sps)

    % Values for the real system, matched filtering first
    % K = 1; % Detector gain
    % DampingFactor = 0.7;
    % NormalizedLoopBandwidth = 0.8;

    % K = 1; % Detector gain
    % DampingFactor = 0.7;
    % NormalizedLoopBandwidth = 0.05;
    
    % Works okay with symbol synchronizer and interleaving
    % K = 1; % Detector gain
    % DampingFactor = 1.3;
    % NormalizedLoopBandwidth = 0.05;

    K = 1; % Detector gain
    DampingFactor = 1.3;
    NormalizedLoopBandwidth = 0.05;

    theta = NormalizedLoopBandwidth/(M*(DampingFactor + 1/(4*DampingFactor)));
    delta = 1 + 2*DampingFactor*theta + theta*theta;

    PhaseRecoveryLoopBandwidth = NormalizedLoopBandwidth*sps;
    PhaseRecoveryGain = sps;
    PhaseErrorDetectorGain = K;
    DigitalSynthesizerGain = -1;
    
    % G1
    ProportionalGain = (4*DampingFactor*theta/delta)/...
        (PhaseErrorDetectorGain*PhaseRecoveryGain);
    % G3
    IntegratorGain = (4/sps*theta*theta/delta)/...
        (PhaseErrorDetectorGain*PhaseRecoveryGain);

    pullinRange = 2*pi*sqrt(2)*DampingFactor*NormalizedLoopBandwidth;

    % Setting up the actual filter objects
    % Using Direct Form II for time optimization
    LoopFilter = dsp.IIRFilter("Structure","Direct form II transposed",...
        "Numerator",[1 0], "Denominator",[1 -1]);
    
    Integrator = dsp.IIRFilter("Structure","Direct form II transposed",...
        "Numerator",[0 1], "Denominator",[1 -1]);

    % MaxFrequencyLockDelay=(4*NormalizedPullInRange^2)/...
    %     (NormalizedLoopBandwidth)^3;
    % 
    % MaxPhaseLockDelay = 1.3/(NormalizedLoopBandwidth);
    % 
    output = zeros(size(rxSignal));

    Phase = 0;
    previousSample = complex(0);

    LoopFilter.release(); Integrator.release();

    for k = 1:length(rxSignal)-1
        output(k) = rxSignal(k+1)*exp(1i*Phase);

        phErr = sign(real(previousSample)).*imag(previousSample) - ...
            real(previousSample).*sign(imag(previousSample));

        loopFiltOut = step(LoopFilter, phErr*IntegratorGain);

        DDSOut = step(Integrator, phErr*ProportionalGain + loopFiltOut);

        % Estimate of the new phase
        Phase = DigitalSynthesizerGain*DDSOut;

        previousSample = output(k);
    end
    
    % scatterplot(output(end-1024:end-10)); title("");

    output = circshift(output, 1);
    output(1) = rxSignal(1)*exp(1i * Phase);
    fineCorrSignal = output;

end