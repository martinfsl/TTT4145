function symbols = pskdemodSelf(rxSignal)
    % Calculate the angle of each received sample
    rxPhases = angle(rxSignal);

    % Preallocate symbols array
    symbols = zeros(size(rxSignal));

    % Gray-coded QPSK Symbol Mapping
    % Quadrant I -> Symbol '00' -> 0
    % Quadrant II -> Symbol '01' -> 1
    % Quadrant III -> Symbol '11' -> 3
    % Quadrant IV -> Symbol '10' -> 2

    % Map the phase of each received sample to the corresponding symbol
    symbols(rxPhases >= -pi/4 & rxPhases < pi/4) = 0;  % Quadrant I
    symbols(rxPhases >= pi/4 & rxPhases < 3*pi/4) = 1; % Quadrant II
    symbols(rxPhases < -pi/4 & rxPhases >= -3*pi/4) = 2; % Quadrant IV
    symbols(rxPhases >= 3*pi/4 & rxPhases <= pi) = 3; % Quadrant III
end
