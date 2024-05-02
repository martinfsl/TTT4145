allHeadersSent = [];

% Setting up junk as filler
rng(9982);
junkSize = amountOfFrames*(length(preamble) + size(bulk_headers, 1) + ...
                           size(headers, 1) + frameSize);
junk = randi([0 M-1], junkSize/2, 1);

% Setting up the messages
rng(1000);
messages = randi([0 M-1], amountOfFrames*frameSize, 1);
messages = reshape(messages, frameSize, amountOfFrames);

l = 1;

bulk_header = bulk_headers(:, l);

l = l + 1;

% Transmitting the signal
bitStream = [];
k = 1; j = 1;

% messages = voiceMessages;

for i = 1:size(messages, 2)
    if k == (size(messages, 2) + 1)
        k = 1;
    end
    if j == (size(headers, 2) + 1)
        j = 1;
    end

    message = messages(:, k);
    header = headers(:, j);

    k = k + 1; j = j + 1;

    bitStream = [bitStream; preamble; bulk_header; header; message];

    if i == 1
        bitStream = [bitStream; preamble; bulk_header; header; message];
    end

    allHeadersSent = [allHeadersSent; ...
        [4*mode(header(1:3)) + 1*mode(header(4:6)), ...
         4*mode(bulk_header(1:3)) + mode(bulk_header(4:6))]];
end

bitStream = [bitStream; preamble; bulk_header; header; message];

bitStream = [junk; bitStream; junk];

% Modulating and transmitting the bit-stream
bitStreamMod = pskmod(bitStream, M, pi/M, "gray");

txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);

% fprintf("%s %i %s %i\n", "Transmitting the signal from bulk: ", temp, " / ", l-1);

transmitRepeat(tx, txSignal);
% tx(txSignal);
