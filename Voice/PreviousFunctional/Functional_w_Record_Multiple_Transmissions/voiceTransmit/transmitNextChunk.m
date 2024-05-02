function transmitNextChunk(headers, bulk_header, preamble, rrcFilter, sps, M)
    global amountOfFrames
    global voiceMessagesToSend
    
    global bulk_control

    global tx

    global junkMod

    disp("Transmit check");

    if size(voiceMessagesToSend, 2) >= amountOfFrames
        disp("Should transmit");
        messages = voiceMessagesToSend(:, 1:amountOfFrames);
        voiceMessagesToSend = voiceMessagesToSend(:, amountOfFrames+1:end);

        bulk_header = bulk_control(:, 1);
        bulk_control = bulk_control(:, 2:end);

        bitStream = [];
        k = 1; j = 1;
        headersSent = [];
        for i = 1:size(messages, 2)
            if k == (size(messages, 2) + 1)
                k = 1;
            end
            if j == 33
                j = 1;
            end

            message = messages(:, k);
            header = headers(:, j);

            k = k + 1; j = j + 1;

            bitStream = [bitStream; preamble; bulk_header; header; message];
        end

        bitStreamMod = pskmod(bitStream, M, pi/M, "gray");

        txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);

        disp("Transmitting the signal");

        transmitRepeat(tx, txSignal);
    else
        transmitRepeat(tx, upfirdn(junkMod, rrcFilter, sps, 1));
    end
end