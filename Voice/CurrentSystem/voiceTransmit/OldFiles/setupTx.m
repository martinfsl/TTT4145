% Setup pulse modulation filter
rolloff = 0.75;
sps = 10;
span = 200;
rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");

partitions = 5;

% preamble = [2; 2; 1; 1; 0; 0; 2; 2; 2; 1; 1; 1; 3; 3; 3; 0; 0; 0];
% preamble = repmat(preamble, 50, 1);
% preamble = repmat(preamble, 50, 1);

preamble1 = [1; 1; 1; 1; 1; 0; 0; 1; 1; 0; 1; 0; 1;]; % Barker code
preamble2 = [3; 3; 3; 3; 3; 2; 2; 3; 3; 2; 3; 2; 3;];
preamble3 = flip(preamble1);
preamble4 = flip(preamble2);

preamble = [preamble1; preamble2; preamble3; preamble4];

M = 4;

headers = [[repmat(0, 3, 1); repmat(0, 3, 1)], ...
           [repmat(0, 3, 1); repmat(1, 3, 1)], ...
           [repmat(0, 3, 1); repmat(2, 3, 1)], ...
           [repmat(0, 3, 1); repmat(3, 3, 1)], ...
           [repmat(1, 3, 1); repmat(0, 3, 1)], ...
           [repmat(1, 3, 1); repmat(1, 3, 1)], ...
           [repmat(1, 3, 1); repmat(2, 3, 1)], ...
           [repmat(1, 3, 1); repmat(3, 3, 1)], ...
           [repmat(2, 3, 1); repmat(0, 3, 1)], ...
           [repmat(2, 3, 1); repmat(1, 3, 1)]];