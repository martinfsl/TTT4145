%%% -----------------------------------------------------
%%% Setting up 

coarseFreqComp = comm.CoarseFrequencyCompensator( ...
    Modulation="qpsk", ...
    SampleRate=sampleRate, ...
    FrequencyResolution=100);

symbolSync = comm.SymbolSynchronizer(...
    'SamplesPerSymbol',sps, ...
    'NormalizedLoopBandwidth',0.05, ...
    'DampingFactor',1, ...
    'TimingErrorDetector','Gardner (non-data-aided)', ...
    'DetectorGain', 2.8);

fineFreqComp = comm.CarrierSynchronizer( ...
    'SamplesPerSymbol',1, ...
    'NormalizedLoopBandwidth',0.01, ...
    'DampingFactor',1, ...
    'Modulation','QPSK');

% detector = comm.PreambleDetector(preambleMod, "Threshold", 30);
detector = comm.PreambleDetector(preambleMod, "Threshold", 25);
