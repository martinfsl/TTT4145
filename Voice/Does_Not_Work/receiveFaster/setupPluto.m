global rx; % Needed for threading

rx = sdrrx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', centerFreq, ...
           'BasebandSampleRate', sampleRate, 'SamplesPerFrame', numSamples, ...
           'OutputDataType', 'double', 'ShowAdvancedProperties', true);

% Use the info method to show the actual values of various hardware-related properties
rxRadioInfo = info(rx)