% run setupModules.m
close all

% profile on

tic
[rxSignal, AAvalidData, AAOverflow] = rx();
% rxSignal = [rxSignal; overlapBuffer];

% release(coarseFreqComp);
% release(symbolSync);
% release(fineFreqComp);

% Matched Filtering
rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);
% rxFiltered = rxFiltered(sps*span+1:end-(sps*span-1));

% CFC
rxSignalCoarse = coarseFreqComp(rxFiltered);

% Timing Synchronization
rxTimingSync = symbolSync(rxSignalCoarse);

% FFC
rxSignalFine = fineFreqComp(rxTimingSync);

[idx, ~] = detector(rxSignalFine);
if ~isempty(idx)
    idx = selectValidIndices(idx, frameSize);
end

if length(idx) > 1
    
    foundPreamble = rxSignalFine(idx(2)-length(preamble)+1:idx(2));
    
    [rxSignalPhaseCorr, phase] = phaseCorrection(rxSignalFine, preambleMod, ...
        foundPreamble);
    
    [foundHeaders, foundMessages] = frameSyncSingle(...
        rxSignalPhaseCorr, idx, frameSize, length(header), M);
    
    for f = 1:size(foundHeaders, 2)
        decodedHeader = foundHeaders(:, f);
        decodedMessage = foundMessages(:, f);
    end
end
% overlapBuffer = rxSignal(end-overlapSize+1:end);

toc

% profile viewer

% scatterplot(rxSignalCoarse);
% scatterplot(rxTimingSync);
% scatterplot(rxSignalFine);
% scatterplot(rxSignalPhaseCorr);
% scatterplot(rxMessage);
