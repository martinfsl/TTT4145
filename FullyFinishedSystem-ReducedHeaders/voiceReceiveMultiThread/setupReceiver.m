% Set up parameters and signals

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

% Also using a flipped version of preamble1 and preamble2
% This gives a better correlational value in the detector
preamble3 = [0; 1; 0; 1; 0; 0; 1; 1; 0; 0; 0; 0; 0];
preamble4 = [2; 3; 2; 3; 2; 2; 3; 3; 2; 2; 2; 2; 2];

preamble = [preamble1; preamble2; preamble3; preamble4];

preambleMod = pskmod(preamble, M, pi/M, "gray");

% Setup pulse modulation filter
% rolloff = 0.5;
rolloff = 0.7;
% sps = 6;
sps = 4;
span = 40;
rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");

% frameSize = 3000;
frameSize = 2000;
% frameSize = 1000;

message = zeros(frameSize, 1);

possibleHeaders = [0,  1,  2,  3,  4,  5,  6,  7];
header = zeros(6, 1);

possibleBulkHeaders = [0, 1,  2,  3,  4,  5,  6,  7, ...
                       8, 9, 10, 11, 12, 13, 14, 15];
bulk_header = zeros(6, 1);

prevRxSignal = 0;

filler = zeros(0, 1);

% bitStream = [message; preamble; header; message];
% bitStream = [preamble; header; message];
bitStream = [filler; preamble; bulk_header; header; message; filler];
bitStreamMod = pskmod(bitStream, M, pi/M, "gray");
%%% -----------------------------------------------------
% Setup the receiver
numSamples = 4*2*(sps*length(bitStream)+span);
% numSamples = 6*2*(sps*length(bitStream)+span);

run setupPluto.m
run setupModules.m
%%% -----------------------------------------------------