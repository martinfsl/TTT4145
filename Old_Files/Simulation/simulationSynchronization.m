% Set-up
close all;
run("Setup/setupParameters.m");

% Transmitter
rng(1);
M = 8;
bitStream = randi([0 M-1], numBits, 1);

% modulatedSignal = pskmod(bitStream, M, pi/M, "gray");
modulatedSignal = qammod(bitStream, M, "gray");

rolloff = 0.5; span = 20; sps = 5; k = log2(M);

rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");
txSignal = upfirdn(modulatedSignal, rrcFilter, sps);



% Channel
% White Gaussian
SignalThroughChannel = awgn(txSignal, 15);
pfo = comm.PhaseFrequencyOffset("PhaseOffset", 0, "FrequencyOffset", 1e5, ...
    "SampleRate", sampleRate);
SignalThroughChannel = step(pfo, SignalThroughChannel);



% Receiver
rxSignal = SignalThroughChannel;

rxFiltered = upfirdn(rxSignal, rrcFilter, 1, sps);
rxFiltered = rxFiltered(span+1:end-span);

% Frequency offset correction
coarseCompensator = comm.CoarseFrequencyCompensator(...
    Modulation = "qam", ...
    SampleRate = sampleRate, ...
    FrequencyResolution = 1);
[rxCoarseComp, estFreqOffset] = coarseCompensator(rxFiltered);

fineSynchronizer = comm.CarrierSynchronizer(...
    "DampingFactor", 0.7, ...
    "NormalizedLoopBandwidth", 0.005, ...
    "SamplesPerSymbol", sps, ...
    "Modulation", "QAM");
rxFineSync = fineSynchronizer(rxCoarseComp);

% Phase offset correction
phaseSync = comm.CarrierSynchronizer('Modulation', 'QAM', 'SamplesPerSymbol', sps);
rxPhaseSync = phaseSync(rxFineSync);

% demodulatedBits = pskdemod(rxFiltered, M, pi/M, "gray");
% demodulatedBits = qamdemod(rxCoarseComp, M, "gray");
% demodulatedBits = qamdemod(rxFineSync, M, "gray");
demodulatedBits = qamdemod(rxPhaseSync, M, "gray");

numError = sum(bitStream ~= demodulatedBits);
Pb = numError/numBits;

% scatterplot(modulatedSignal);
% scatterplot(rxFiltered);

% eyediagram(modulatedSignal, 2*sps);
% eyediagram(txSignal, 2*sps);
% eyediagram(rxFiltered, 2*sps);
% eyediagram(rxCoarseComp, 2*sps);

% sa = spectrumAnalyzer(...
%     SampleRate = sampleRate, ...
%     ShowLegend = true, ...
%     ChannelNames = ["Offset signal", "Compensated signal"]);
% sa([rxFiltered, rxCoarseComp]);

scatterplot(modulatedSignal);
scatterplot(rxFiltered);
scatterplot(rxFineSync);
scatterplot(rxPhaseSync);
