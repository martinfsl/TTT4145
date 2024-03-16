% Set up parameters and signals
% sampleRate = 5e6;
sampleRate = 1e6;
% centerFreq = 1.8e9;
centerFreq = 1.804e9;

M = 4;

%%% -----------------------------------------------------
% preamble    = [2; 2; 1; 1; 0; 0; 2; 2; 2; 1; 1; 1; 3; 3; 3; 0; 0; 0];
% preamble    = repmat(preamble, 40, 1);
% preamble    = repmat(preamble, 50, 1);
% preamble    = repmat(preamble, 5, 1);

preamble1 = [1; 1; 1; 1; 1; 0; 0; 1; 1; 0; 1; 0; 1]; % Barker code
preamble2 = [3; 3; 3; 3; 3; 2; 2; 3; 3; 2; 3; 2; 3];
preamble3 = flip(preamble1);
preamble4 = flip(preamble2);

preamble = [preamble1; preamble2; preamble3; preamble4];

preambleMod = pskmod(preamble, M, pi/M, "gray");

% Setup pulse modulation filter
rolloff = 0.75;
sps = 10;
span = 200;
rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");

frameSize = 2900;

message = zeros(frameSize, 1);

rng(1);
trueMessage = randi([0 M-1], frameSize, 1);

possibleHeaders = [0,  1,  2,  3,  4,  5,  6,  7, ...
                   8,  9, 10, 11, 12, 13, 14, 15, ...
                  16, 17, 18, 19, 20, 21, 22, 23, ...
                  24, 25, 26, 27, 28, 29, 30, 31];
header = zeros(9, 1);

prevRxSignal = 0;

filler = zeros(200, 1);

% bitStream = [message; preamble; header; message];
% bitStream = [preamble; header; message];
bitStream = [filler; preamble; header; message; filler];
bitStreamMod = pskmod(bitStream, M, pi/M, "gray");
%%% -----------------------------------------------------
% Setup the receiver
% numSamples = 3000;
% numSamples = round(3*length(upfirdn(bitStreamMod, rrcFilter, sps, 1))) + 1;
numSamples = round(2*length(upfirdn(bitStreamMod, rrcFilter, sps, 1)));

run setupPluto.m
run setupModules.m