% message = messages(:, i);
% header = headers(:, i);

filler = randi([0 M-1], fillerSize*2, 1);

% bitStream = [preamble; headers(:, 1); messages(:, 1); preamble; headers(:, 2); messages(:, 2);];

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

    headersSent = [headersSent, j-1];

    k = k + 1; j = j + 1;

    bitStream = [bitStream; preamble; header; message];
end

bitStreamMod = pskmod(bitStream, M, pi/M, "gray");

txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);

tic
disp("Transmitting the signal");

transmitRepeat(tx, txSignal);

% pause(0.5);
% release(tx);
% disp("Finished transmission");
% toc