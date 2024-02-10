% Set up parameters and signals
sampleRate = 5e6;
centerFreq = 1.8e9;

sps = 4;
span = 20;

M = 4;

preamble = [1; 1; 1; 1; 1; 0; 0; 1; 1; 0; 1; 0; 1];
% preamble = [2; 2; 1; 1; 0; 0; 2; 2; 2; 1; 1; 1; 3; 3; 3; 0; 0; 0];
preamble = repmat(preamble, 4, 1);
message = [1; 0; 1; 0; 1; 0; 1; 0; 1; 0]; 
% message = repmat(3, 20, 1);

bitStream = [preamble; message];

preambleMod = pskmod(preamble, M, pi/M, "gray");
bitStreamMod = pskmod(bitStream, M, pi/M, "gray");

% Setup pulse modulation filter
rolloff = 0.6;
rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");

% Setup transmit-signal
txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);

% Setup the transmitter
tx = sdrtx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', centerFreq, ...
           'BasebandSampleRate', sampleRate, 'Gain', 0, ...
           'ShowAdvancedProperties', true);
       
% Use the info method to show the actual values of various hardware-related properties
txRadioInfo = info(tx)