% -----------------------------------------------------------------------
% PARAMETERS
sampleRate = 1e6;
M = 4;
% -----------------------------------------------------------------------
% SETUP PULSE MODULATION FILTER
rolloff = 0.75;
sps = 10;
span = 200;
rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");
% -----------------------------------------------------------------------
% -----------------------------------------------------------------------
% PREAMBLE
preamble1 = [1; 1; 1; 1; 1; 0; 0; 1; 1; 0; 1; 0; 1]; % Barker code
preamble2 = [3; 3; 3; 3; 3; 2; 2; 3; 3; 2; 3; 2; 3];
preamble3 = flip(preamble1);
preamble4 = flip(preamble2);

preamble = [preamble1; preamble2; preamble3; preamble4];

preambleMod = pskmod(preamble, M, pi/M, "gray");
% -----------------------------------------------------------------------
% -----------------------------------------------------------------------
% MESSAGE AND SIGNAL
possibleHeaders = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
header = zeros(6, 1);

frameSize = 1000;
message = zeros(frameSize, 1);

rng(1);
trueMessage = randi([0 M-1], 1000, 1);

rng(5243);
filler1 = randi([0 M-1], 200, 1);
rng(51320);
filler2 = randi([0 M-1], 200, 1);

bitStream = [filler1; preamble; header; trueMessage; filler2];
bitStreamMod = pskmod(bitStream, M, pi/M, "gray");

txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);
prevRxSignal = [];
% -----------------------------------------------------------------------
% -----------------------------------------------------------------------
% SETTING UP MODULES
coarseFreqComp = comm.CoarseFrequencyCompensator( ...
    Modulation="qpsk", ...
    SampleRate=sampleRate, ...
    FrequencyResolution=100);

symbolSync = comm.SymbolSynchronizer(...
    'SamplesPerSymbol',sps, ...
    'NormalizedLoopBandwidth',0.01, ...
    'DampingFactor',1, ...
    'TimingErrorDetector','Gardner (non-data-aided)', ...
    'DetectorGain', 2.8);

fineFreqComp = comm.CarrierSynchronizer( ...
    'SamplesPerSymbol',1, ...
    'NormalizedLoopBandwidth',0.01, ...
    'DampingFactor',1, ...
    'Modulation','QPSK');
% -----------------------------------------------------------------------