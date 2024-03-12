% function timingCorrSignal = timingCorrGardner(rxFiltered, M, sps)
function [timingCorrSignal, timingError] = timingCorrGardner(rxSignal, M, sps)
    
    mu = 0.3;
    InterpFilterState = [0; 0; 0]; % Intializing

    % Defining the interpolator
    alpha = 0.5;
    InterpFilterCoeff = ...
        [0, 0, 1, 0; % Constant
         -alpha, (1+alpha), -(1-alpha), -alpha; % Linear
         alpha, -alpha, -alpha, alpha; % Cubic
        ];

    for i = 1:length(rxSignal)
        % Interpolator input
        ySeq = [rxSignal(i); InterpFilterState]; % Update delay line
        % Interpolator output
        interpOut = sum((InterpFilterCoeff * ySeq)) .* [1; mu; mu^2];
        InterpFilterState = ySeq(1:3);
        disp(interpOut);
    end

    timingCorrSignal = 0; timingError = 0;

end



