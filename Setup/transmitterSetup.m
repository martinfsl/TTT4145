% Set up parameters and signals
sampleRate = 200e3;
centerFreq = 2.4e9;

% Set up the transmitter
% Use the default value of 0 for FrequencyCorrection, which corresponds to 
% the factory-calibrated condition
tx = sdrtx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', centerFreq, ...
           'BasebandSampleRate', sampleRate, 'Gain', 0, ...
           'ShowAdvancedProperties', true);
       
% Use the info method to show the actual values of various hardware-related properties
txRadioInfo = info(tx)