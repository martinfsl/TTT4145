symbolSync = comm.SymbolSynchronizer(...
    'SamplesPerSymbol',sps, ...
    'NormalizedLoopBandwidth',0.005, ...
    'DampingFactor',1, ...
    'TimingErrorDetector','Early-Late (non-data-aided)');

