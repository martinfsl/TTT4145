function [frameSynced, rxMessage, rxHeader] = ...
    frameSyncSingle(rxSignal, frameStart, preamble, frameSize, header)

    % if frameStart < 0
    %     rxPreamble = zeros(length(preamble), 1);
    % else
    %     rxPreamble = rxSignal(frameStart:frameStart+length(preamble)-1);
    % end

    rxMessage = ...
        rxSignal(frameStart+length(preamble)+length(header):...
                 frameStart+length(preamble)+length(header)+frameSize-1);

    rxHeader = rxSignal(frameStart+length(preamble):...
                        frameStart+length(preamble)+length(header)-1);

    frameSynced = rxSignal;
end