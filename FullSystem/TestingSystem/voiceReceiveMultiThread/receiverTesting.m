allHeadersAcrossBulks = [];

corrVal = 0;

overlapSize = sps*(length(bitStream)) + span + 100;
overlapBuffer = zeros(overlapSize, 1);

phase = 0;

% Backward View
bwView = 2;

while true

    [rxSignal, AAvalidData, AAOverflow] = rx();

    rxSignal = [overlapBuffer; rxSignal];

    release(coarseFreqComp);
    release(symbolSync);
    release(fineFreqComp);
    
    % Matched Filtering
    rxFiltered = upfirdn(rxSignal, rrcFilter, 1, 1);

    % CFC
    rxSignalCoarse = coarseFreqComp(rxFiltered);
    
    % Timing Synchronization
    rxTimingSync = symbolSync(rxSignalCoarse);
    
    % Preamble detector
    [idx, ~] = detector(rxTimingSync);

    % This is to avoid getting indices during start up where
    % the correlation is 'mushed'   
    if ~isempty(idx)
        idx = selectValidIndices(idx, frameSize);
    end

    if length(idx) > 1

        % Finding all packets based on the preamble detector
        rxPackets = extractHeadersMessages(idx, rxTimingSync, ...
                    frameSize, length(bulk_header)+length(header), length(preamble));

        for f = 1:size(rxPackets, 2)
            % FFC
            rxSignalFine = fineFreqComp(rxPackets(:, f));

            % Extracting the preamble from this packet
            foundPreamble = rxSignalFine(1:length(preamble));

            % Phase correction
            [rxSignalPhaseCorr, ~] = phaseCorrection(rxSignalFine, preambleMod, ...
                foundPreamble);

            rxHeader = rxSignalPhaseCorr(1+length(preamble):...
                            length(preamble)+headerSize);
            rxMessage = rxSignalPhaseCorr(1+length(preamble)+headerSize:...
                            length(preamble)+headerSize+frameSize);

            decodedHeader = pskdemod(rxHeader, M, pi/M, "gray");
            decodedMessage = pskdemod(rxMessage, M, pi/M, "gray");

            h_bulk = 4*mode(decodedHeader(1:3)) + ...
                       mode(decodedHeader(4:6));

            h = 4*mode(decodedHeader(7:9)) + ...
                1*mode(decodedHeader(10:12));

            % Check if header has been read before
            % (Old implementation, might be removed)
            if checkIfUnique(...
                    allHeadersAcrossBulks, h, bwView, possibleHeaders)

                fprintf("%s %s %i %s %i \n", ...
                    "New message found", ...
                    "header: ", h, ...
                    "bulk: ", h_bulk);

                allHeadersAcrossBulks = [allHeadersAcrossBulks; ...
                        [h, h_bulk, "message:", decodedMessage']];
            end
        end
    end

    overlapBuffer = rxSignal(end-overlapSize+1:end);
end