% frameSize = 2900;

% release(tx);

% quality = 25; partitions = 5;
% messages = getSymbolsImage(quality, partitions, 'Lena/Lena.png', 'Lena');

quality = 10; partitions = 13;
messages = getSymbolsImage(quality, partitions, 'Trondheim/Trondheim.jpg', 'Trondheim');

frameSize = size(messages, 1);

transmittedMessages = [];

j = 1; k = 1;
for i = 1:size(messages, 2)
    if j == (size(messages, 2)+1)
        j = 1;
    end
    if k == 33
        k = 1;
    end

    message = messages(:, j);
    header = headers(:, k);

    j = j + 1; 
    k = k + 1;

    rng(320); filler1 = randi([0 M-1], fillerSize, 1);
    rng(520); filler2 = randi([0 M-1], fillerSize, 1);

    bitStream = [filler1; preamble; header; message; filler2];
    bitStreamMod = pskmod(bitStream, M, pi/M, "gray");

    txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);

    transmitRepeat(tx, txSignal);

    fprintf("%s %i \n", "Transmitting: ", i);

    transmittedMessages = [transmittedMessages, message];

    pause(10);
end