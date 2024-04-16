%%% ---------------------------------------------------
% Setup parameters
% frameSize = 14500;
% frameSize = size(messages, 1);
frameSize = 3000;
M = 4;
% fillerSize = 1000000;
fillerSize = 0;

% frameSize = 3000;
global amountOfFrames
% amountOfFrames = 20;
amountOfFrames = 18;

%%% ---------------------------------------------------

%%% ---------------------------------------------------
% Setup pulse modulation filter
rolloff = 0.5;
sps = 8;
span = 40;
rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");
%%% ---------------------------------------------------

%%% ---------------------------------------------------
% Setup preamble
preamble1 = [1; 1; 1; 1; 1; 0; 0; 1; 1; 0; 1; 0; 1;]; % Barker code
preamble2 = [3; 3; 3; 3; 3; 2; 2; 3; 3; 2; 3; 2; 3;];
% preamble3 = flip(preamble1);
% preamble4 = flip(preamble2);

preamble3 = [0; 1; 0; 1; 0; 0; 1; 1; 0; 0; 0; 0; 0];
preamble4 = [2; 3; 2; 3; 2; 2; 3; 3; 2; 2; 2; 2; 2];

preamble = [preamble1; preamble2; preamble3; preamble4];
% preamble = [preamble1; preamble2];
%%% ---------------------------------------------------

%%% ---------------------------------------------------
% Setup headers
headers = [[repmat(0, 3, 1); repmat(0, 3, 1); repmat(0, 3, 1)], ...
           [repmat(0, 3, 1); repmat(0, 3, 1); repmat(1, 3, 1)], ...
           [repmat(0, 3, 1); repmat(0, 3, 1); repmat(2, 3, 1)], ...
           [repmat(0, 3, 1); repmat(0, 3, 1); repmat(3, 3, 1)], ...
           [repmat(0, 3, 1); repmat(1, 3, 1); repmat(0, 3, 1)], ...
           [repmat(0, 3, 1); repmat(1, 3, 1); repmat(1, 3, 1)], ...
           [repmat(0, 3, 1); repmat(1, 3, 1); repmat(2, 3, 1)], ...
           [repmat(0, 3, 1); repmat(1, 3, 1); repmat(3, 3, 1)], ...
           [repmat(0, 3, 1); repmat(2, 3, 1); repmat(0, 3, 1)], ...
           [repmat(0, 3, 1); repmat(2, 3, 1); repmat(1, 3, 1)], ...
           [repmat(0, 3, 1); repmat(2, 3, 1); repmat(2, 3, 1)], ...
           [repmat(0, 3, 1); repmat(2, 3, 1); repmat(3, 3, 1)], ...
           [repmat(0, 3, 1); repmat(3, 3, 1); repmat(0, 3, 1)], ...
           [repmat(0, 3, 1); repmat(3, 3, 1); repmat(1, 3, 1)], ...
           [repmat(0, 3, 1); repmat(3, 3, 1); repmat(2, 3, 1)], ...
           [repmat(0, 3, 1); repmat(3, 3, 1); repmat(3, 3, 1)], ...
           [repmat(1, 3, 1); repmat(0, 3, 1); repmat(0, 3, 1)], ...
           [repmat(1, 3, 1); repmat(0, 3, 1); repmat(1, 3, 1)], ...
           [repmat(1, 3, 1); repmat(0, 3, 1); repmat(2, 3, 1)], ...
           [repmat(1, 3, 1); repmat(0, 3, 1); repmat(3, 3, 1)], ...
           [repmat(1, 3, 1); repmat(1, 3, 1); repmat(0, 3, 1)], ...
           [repmat(1, 3, 1); repmat(1, 3, 1); repmat(1, 3, 1)], ...
           [repmat(1, 3, 1); repmat(1, 3, 1); repmat(2, 3, 1)], ...
           [repmat(1, 3, 1); repmat(1, 3, 1); repmat(3, 3, 1)], ...
           [repmat(1, 3, 1); repmat(2, 3, 1); repmat(0, 3, 1)], ...
           [repmat(1, 3, 1); repmat(2, 3, 1); repmat(1, 3, 1)], ...
           [repmat(1, 3, 1); repmat(2, 3, 1); repmat(2, 3, 1)], ...
           [repmat(1, 3, 1); repmat(2, 3, 1); repmat(3, 3, 1)], ...
           [repmat(1, 3, 1); repmat(3, 3, 1); repmat(0, 3, 1)], ...
           [repmat(1, 3, 1); repmat(3, 3, 1); repmat(1, 3, 1)], ...
           [repmat(1, 3, 1); repmat(3, 3, 1); repmat(2, 3, 1)], ...
           [repmat(1, 3, 1); repmat(3, 3, 1); repmat(3, 3, 1)]];

bulk_headers = [[repmat(0, 3, 1); repmat(0, 3, 1)], ...
                [repmat(0, 3, 1); repmat(1, 3, 1)], ...
                [repmat(0, 3, 1); repmat(2, 3, 1)], ...
                [repmat(0, 3, 1); repmat(3, 3, 1)], ...
                [repmat(1, 3, 1); repmat(0, 3, 1)], ...
                [repmat(1, 3, 1); repmat(1, 3, 1)], ...
                [repmat(1, 3, 1); repmat(2, 3, 1)], ...
                [repmat(1, 3, 1); repmat(3, 3, 1)], ...
                [repmat(2, 3, 1); repmat(0, 3, 1)], ...
                [repmat(2, 3, 1); repmat(1, 3, 1)], ...
                [repmat(2, 3, 1); repmat(2, 3, 1)], ...
                [repmat(2, 3, 1); repmat(3, 3, 1)], ...
                [repmat(3, 3, 1); repmat(0, 3, 1)], ...
                [repmat(3, 3, 1); repmat(1, 3, 1)], ...
                [repmat(3, 3, 1); repmat(2, 3, 1)], ...
                [repmat(3, 3, 1); repmat(3, 3, 1)]];
%%% ---------------------------------------------------