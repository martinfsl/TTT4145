% Placeholder for updated fineCorrSignal function incorporating Gardner TED
function fineCorrSignal = fineCorrectionWithGardner(rxSignal, M, sps)
    % Existing setup code here...

        % Coefficients
    K = 1; % Detector gain
    DampingFactor = 0.7;
    NormalizedLoopBandwidth = 0.8;

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
    
    % Initialize Gardner TED related variables
    timingError = 0; % Initial timing error
    timingAdjustment = 0; % Initial timing adjustment, perhaps in samples
    
    % Placeholder loop filter for timing correction (simplified)
    timingLoopFilter = dsp.IIRFilter('Numerator', [0.01], 'Denominator', [1 -0.99]);
    
    for k = 2:length(rxSignal)-2
        % Assuming 'k' indexes properly into your oversampled signal...
        % Gardner timing error detection
        midSample = rxSignal(k); % Midpoint sample
        earlySample = rxSignal(k-1); % Early sample
        lateSample = rxSignal(k+1); % Late sample
        
        timingError = midSample * (lateSample - earlySample);
        
        % Update timing adjustment via loop filter
        timingAdjustment = step(timingLoopFilter, timingError);
        
        % Adjust your processing based on timingAdjustment...
        % This might involve interpolating between samples to correct timing
        
        % Frequency correction processing as before...
        % Incorporate timing adjustments into your sample selection or interpolation
    end
    
    % Continue with frequency correction processing...
end
