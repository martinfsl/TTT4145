% Set up parameters and signals
% sampleRate = 5e6;
sampleRate = 1e6;
% centerFreq = 1.8e9;
centerFreq = 1.805e9;

M = 4;

% preamble = [1; 1; 1; 1; 1; 0; 0; 1; 1; 0; 1; 0; 1]; % Barker code
% preamble= [2; 2; 1; 1; 0; 0; 2; 2; 2; 1; 1; 1; 3; 3; 3; 0; 0; 0]; % Works best
% preamble = repmat(preamble, 10, 1); % Works best
% message = [3; 2; 1; 0];
% message = repmat(message, 50, 1);

% For voice
% message = zeros(29752, 1);
% message = zeros(29752/2, 1);
% message = zeros(141120, 1);

% bitStream = [preamble; message;];
% bitStreamMod = pskmod(bitStream, M, pi/M, "gray");
% preambleMod = pskmod(preamble, M, pi/M, "gray");

%%% -----------------------------------------------------
% Preamble in the middle
preamble    = [2; 2; 1; 1; 0; 0; 2; 2; 2; 1; 1; 1; 3; 3; 3; 0; 0; 0];
preamble    = repmat(preamble, 10, 1);
% preamble    = repmat(preamble, 50, 1);
% preamble    = repmat(preamble, 40, 1);
preambleMod = pskmod(preamble, M, pi/M, "gray");

% frameSize = 14876;
frameSize = 3719;
message = zeros(frameSize, 1);

header = zeros(3, 1);

allRxSignals = [];
allRxMessages = [];
allDecodedMessages = [];
allReceivedHeaders = [];

% message = [3; 2; 1; 0;];
% message = repmat(message, 25, 1);
% txMessage = [message; message];

message1 = repmat([3; 2; 1; 0;], 20, 1);
message2 = repmat([0; 1; 2; 3;], 20, 1);
bitStream = [message1; preamble; header; message2];
frameSize = 80;

% bitStream = [message; preamble; header; message];
bitStreamMod = pskmod(bitStream, M, pi/M, "gray");
%%% -----------------------------------------------------

% Setup pulse modulation filter
rolloff = 0.6;
sps = 20;
span = 200;
rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");

% Setup the receiver
% numSamples = 3000;
% numSamples = 3*length(upfirdn(bitStreamMod, rrcFilter, sps, 1));
numSamples = round(4*length(upfirdn(bitStreamMod, rrcFilter, sps, 1)));
rx = sdrrx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', centerFreq, ...
           'BasebandSampleRate', sampleRate, 'SamplesPerFrame', numSamples, ...
           'OutputDataType', 'double', 'ShowAdvancedProperties', true);
       
% Use the info method to show the actual values of various hardware-related properties
rxRadioInfo = info(rx)
