% Set up parameters and signals
% sampleRate = 5e6;
sampleRate = 1e6;
centerFreq = 1.805e9;

M = 4;

run("setupTxSignal.m");

preambleMod = pskmod(preamble, M, pi/M, "gray");
% preambleMod = pskmod(preamble, M, pi/M, "gray", "InputType", "bit");
bitStreamMod = pskmod(bitStream, M, pi/M, "gray");
% bitStreamMod = pskmod(bitStream, M, pi/M, "gray", "InputType", "bit");

% Setup pulse modulation filter
rolloff = 0.6;
sps = 4;
span = 20;
rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");

% Setup transmit-signal
txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);

% Setup the transmitter
tx = sdrtx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', centerFreq, ...
           'BasebandSampleRate', sampleRate, 'Gain', 0, ...
           'ShowAdvancedProperties', true);
       
% Use the info method to show the actual values of various hardware-related properties
txRadioInfo = info(tx)