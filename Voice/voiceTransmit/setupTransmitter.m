% Set up parameters and signals
% sampleRate = 5e6;
% sampleRate = 1e6;
sampleRate = 1e6;
centerFreq = 1.804e9;
% centerFreq = 1.798e9;

% Setup the transmitter
tx = sdrtx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', centerFreq, ...
           'BasebandSampleRate', sampleRate, 'Gain', 0, ...
           'ShowAdvancedProperties', true);
       
% Use the info method to show the actual values of various hardware-related properties
txRadioInfo = info(tx)