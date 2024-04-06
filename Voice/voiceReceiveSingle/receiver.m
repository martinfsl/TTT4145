allHeaders = []; 

corrVal = 0;
isUnique = 0;

overlapSize = sps*(length(bitStream) + span) + 40;
overlapBuffer = zeros(overlapSize, 1);

buffer = [];
bufferSize = 10;

deviceWriter = audioDeviceWriter('SampleRate', 16000, 'BufferSize', frameSize/4);
% deviceWriter = audioDeviceWriter('SampleRate', 44100, 'BufferSize', frameSize/4);

% audioSize = 29000/4;
setup(deviceWriter, zeros(frameSize/4, 1));

phase = 0;

backwardView = 1;

amountReceived = 50;
while length(allHeaders) < amountReceived
    tic
    [rxSignal, AAvalidData, AAOverflow] = rx();

    rxSignal = [overlapBuffer; rxSignal];

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
    
    [idx,detmet] = detector(rxSignalFine);
    
    if ~isempty(idx)

        rxSignalFine = rxSignalFine .* exp(-1i * phase);

        foundPreamble = rxSignalFine(idx(2)-length(preamble)+1:idx(2));

        [rxSignalPhaseCorr, phase] = phaseCorrection(rxSignalFine, preambleMod, ...
            foundPreamble);


        [foundHeaders, foundMessages] = frameSyncSingle(...
            rxSignalPhaseCorr, idx, frameSize, length(header), M);

        for f = 1:size(foundHeaders, 2)
            decodedHeader = foundHeaders(:, f);
            decodedMessage = foundMessages(:, f);

            h = 16*mode(decodedHeader(1:3)) + ...
                 4*mode(decodedHeader(4:6)) + ...
                 1*mode(decodedHeader(7:9));
            
            if (length(allHeaders) > backwardView)
                if (~ismember(h, allHeaders(end-backwardView:end)) && ...
                     ismember(h, possibleHeaders))
                    isUnique = 1;
                end
            elseif (length(allHeaders) <= backwardView)
                if (~ismember(h, allHeaders) && ...
                     ismember(h, possibleHeaders))
                    isUnique = 1;
                end
            end
    
            if isUnique
                fprintf("%s %i \n", "New message found - header: ", h+1);
    
                % error = min(symerr(decodedMessage, trueMessages));
                % fprintf("%s %i %s %i \n", "The error was: ", error, " in header ", h+1);
    
                buffer = [buffer, decodedMessage];
                disp(size(buffer, 2));
                if size(buffer, 2) == bufferSize
                    disp("Playing sound");
                    
                    deviceWriter(reconstructVoiceSignal(buffer(:, 1)));
    
                    % recVoice = reconstructVoiceSignal([buffer(:, 1); buffer(:, 2)]);
                    % sound(recVoice, 16000);
                    
                    buffer = buffer(:, 2:end);
                end
    
                allHeaders = [allHeaders; h];
            end
        end
    end
    isUnique = 0;

    overlapBuffer = rxSignal(end-overlapSize+1:end);

    toc
end