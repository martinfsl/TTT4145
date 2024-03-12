% Set up parameters and signals
% sampleRate = 5e6;
sampleRate = 1e6;
% centerFreq = 1.8e9;
centerFreq = 1.804e9;

M = 4;

%%% -----------------------------------------------------
preamble1 = [1; 1; 1; 1; 1; 0; 0; 1; 1; 0; 1; 0; 1]; % Barker code
preamble2 = [3; 3; 3; 2; 2; 2; 3; 2; 2; 3; 2]; % Barker code phase-shifter
preamble3 = [2; 2; 2; 0; 0; 2; 0]; % Barker code phase-shifter
preamble = [preamble1; preamble2; preamble3];

preambleMod = pskmod(preamble, M, pi/M, "gray");

frameSize = 1000;
message = zeros(frameSize, 1);

bitStream = [message; preamble; message];
bitStreamMod = pskmod(bitStream, M, pi/M, "gray");
%%% -----------------------------------------------------

% Setup pulse modulation filter
rolloff = 0.85;
sps = 8;
span = 20;
rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");

% Setup the receiver
% numSamples = 3000;
numSamples = 3*length(upfirdn(bitStreamMod, rrcFilter, sps, 1))+1;
rx = sdrrx('Pluto', 'RadioID', 'usb:0', 'CenterFrequency', centerFreq, ...
           'BasebandSampleRate', sampleRate, 'SamplesPerFrame', numSamples, ...
           'OutputDataType', 'double', 'ShowAdvancedProperties', true);
       
% Use the info method to show the actual values of various hardware-related properties
rxRadioInfo = info(rx)

%%% -----------------------------------------------------
% Receive signal

rxSignal = rx();

rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

rxSignalCoarse = coarseCorrectionFFT(rxFiltered, M, sampleRate);

rxSignalFine = fineCorrection(rxSignalCoarse, M, sps);

scatterplot(rxSignalCoarse);
scatterplot(rxSignalFine);
