% Set up parameters and signals
% sampleRate = 5e6;
sampleRate = 1e6;
% centerFreq = 1.8e9;
centerFreq = 1.804e9;

M = 4;

%%% -----------------------------------------------------

preamble1 = [1; 1; 1; 1; 1; 0; 0; 1; 1; 0; 1; 0; 1]; % Barker code
preamble2 = [3; 3; 3; 3; 3; 2; 2; 3; 3; 2; 3; 2; 3];
% preamble2 = [3; 3; 3; 2; 2; 2; 3; 2; 2; 3; 2]; % Barker code phase-shifter
% preamble3 = [2; 2; 2; 0; 0; 2; 0]; % Barker code phase-shifter
preamble = [preamble1; preamble2];

preambleMod = pskmod(preamble, M, pi/M, "gray");

% Setup pulse modulation filter
rolloff = 0.85;
sps = 8;
span = 20;
rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");

frameSize = 1000;

message = zeros(frameSize, 1);

possibleHeaders = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
header = zeros(6, 1);

% bitStream = [message; preamble; header; message];
bitStream = [preamble; header; message];
bitStreamMod = pskmod(bitStream, M, pi/M, "gray");
%%% -----------------------------------------------------

% Setup the receiver
% numSamples = 3000;
% numSamples = 3*length(upfirdn(bitStreamMod, rrcFilter, sps, 1)) + 1;
numSamples = round(2.5*length(upfirdn(bitStreamMod, rrcFilter, sps, 1)))+1;

rx = sdrrx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', centerFreq, ...
           'BasebandSampleRate', sampleRate, 'SamplesPerFrame', numSamples, ...
           'OutputDataType', 'double', 'ShowAdvancedProperties', true);

% Use the info method to show the actual values of various hardware-related properties
rxRadioInfo = info(rx)

% run setupModules.m