% Set up parameters and signals
% sampleRate = 5e6;
sampleRate = 1e6;
% centerFreq = 1.8e9;
centerFreq = 1.805e9;

M = 4;

% preamble = [1; 1; 1; 1; 1; 0; 0; 1; 1; 0; 1; 0; 1];
preamble= [2; 2; 1; 1; 0; 0; 2; 2; 2; 1; 1; 1; 3; 3; 3; 0; 0; 0];
% preamble = repmat(preamble, 4, 1);
preamble = repmat(preamble, 40, 1);
% preamble2 = [2; 2; 2; 2; 2; 3; 3; 2; 2; 3; 2; 3; 2];
% preamble = [preamble; preamble2];
% message = [1; 0; 1; 0; 1; 0; 1; 0; 1; 0];
% message = repmat(message, 5, 1);
% message = repmat(3, 20, 1);
% message = [3; 2; 1; 0];
% message = repmat(message, 2000, 1);

% message1 = [3; 2; 1; 0];
% message1 = repmat(message1, 10, 1);
% message2 = [0; 1; 2; 3];
% message2 = repmat(message2, 10, 1);
% message = [message2; message1];

% For voice
% message = zeros(29752, 1);
message = zeros(141120, 1);

bitStream = [preamble; message];

preambleMod = pskmod(preamble, M, pi/M, "gray");
bitStreamMod = pskmod(bitStream, M, pi/M, "gray");

% Setup pulse modulation filter
rolloff = 0.6;
sps = 4;
span = 20;
rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");

% Setup the receiver
% numSamples = 3000;
numSamples = 2*length(upfirdn(bitStreamMod, rrcFilter, sps, 1));
rx = sdrrx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', centerFreq, ...
           'BasebandSampleRate', sampleRate, 'SamplesPerFrame', numSamples, ...
           'OutputDataType', 'double', 'ShowAdvancedProperties', true);
       
% Use the info method to show the actual values of various hardware-related properties
rxRadioInfo = info(rx)
