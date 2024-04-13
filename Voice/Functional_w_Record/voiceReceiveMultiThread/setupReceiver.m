% Set up parameters and signals
% sampleRate = 5e6;
% sampleRate = 1e6;
% sampleRate = 2e6;
% centerFreq = 1.8e9;
% centerFreq = 1.804e9;

% sampleRate = 200e3;
% sampleRate = 1e6;
sampleRate = 750e3;
% centerFreq = 1.802e9;
centerFreq = 1.799e9;

M = 4;

%%% -----------------------------------------------------
% preamble    = [2; 2; 1; 1; 0; 0; 2; 2; 2; 1; 1; 1; 3; 3; 3; 0; 0; 0];
% preamble    = repmat(preamble, 40, 1);
% preamble    = repmat(preamble, 50, 1);
% preamble    = repmat(preamble, 5, 1);

preamble1 = [1; 1; 1; 1; 1; 0; 0; 1; 1; 0; 1; 0; 1]; % Barker code
preamble2 = [3; 3; 3; 3; 3; 2; 2; 3; 3; 2; 3; 2; 3];
% preamble3 = flip(preamble1);
% preamble4 = flip(preamble2);

preamble3 = [0; 1; 0; 1; 0; 0; 1; 1; 0; 0; 0; 0; 0];
preamble4 = [2; 3; 2; 3; 2; 2; 3; 3; 2; 2; 2; 2; 2];

preamble = [preamble1; preamble2; preamble3; preamble4];
% preamble = [preamble1; preamble2];

preambleMod = pskmod(preamble, M, pi/M, "gray");

% Setup pulse modulation filter
rolloff = 0.5;
sps = 8;
span = 40;
rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");

% frameSize = 2900;
frameSize = 3000;
% frameSize = 5800;
% frameSize = 8000;
% frameSize = 14500;
% frameSize = 29000;

message = zeros(frameSize, 1);

possibleHeaders = [0,  1,  2,  3,  4,  5,  6,  7, ...
                   8,  9, 10, 11, 12, 13, 14, 15, ...
                  16, 17, 18, 19, 20, 21, 22, 23, ...
                  24, 25, 26, 27, 28, 29, 30, 31];
header = zeros(9, 1);

prevRxSignal = 0;

filler = zeros(0, 1);

% bitStream = [message; preamble; header; message];
% bitStream = [preamble; header; message];
bitStream = [filler; preamble; header; message; filler];
bitStreamMod = pskmod(bitStream, M, pi/M, "gray");
%%% -----------------------------------------------------
% Setup the receiver
numSamples = 4*2*(sps*length(bitStream)+span);

run setupPluto.m
run setupModules.m
%%% -----------------------------------------------------