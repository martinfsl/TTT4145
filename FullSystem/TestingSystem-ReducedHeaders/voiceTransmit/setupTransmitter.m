% Set up parameters and signals

% sampleRate = 1e6;
sampleRate = 750e3;

% centerFreq = 1.802e9;
centerFreq = 1.799e9;

% Setup the transmitter
global tx
tx = sdrtx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', centerFreq, ...
           'BasebandSampleRate', sampleRate, 'Gain', 0, ...
           'ShowAdvancedProperties', true);
       
% Use the info method to show the actual values of various hardware-related properties
txRadioInfo = info(tx)

% run readVoiceMessage.m
run setupParameters.m