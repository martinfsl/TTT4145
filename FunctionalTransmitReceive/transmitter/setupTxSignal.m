[messageVoice, Fs] = setupVoiceFromFile("stry(1).wav");
% [message, Fs] = setupVoiceFromFile("cranking_1.wav");

messageVoice = messageVoice(1:29500);

% message1 = message(1:length(message)/2);
% message2 = message(length(message)/2 + 1:end);

run setupTx.m

headers = [[repmat(0, 3, 1); repmat(0, 3, 1)], ...
           [repmat(0, 3, 1); repmat(1, 3, 1)], ...
           [repmat(0, 3, 1); repmat(2, 3, 1)], ...
           [repmat(0, 3, 1); repmat(3, 3, 1)], ...
           [repmat(1, 3, 1); repmat(0, 3, 1)], ...
           [repmat(1, 3, 1); repmat(1, 3, 1)], ...
           [repmat(1, 3, 1); repmat(2, 3, 1)], ...
           [repmat(1, 3, 1); repmat(3, 3, 1)], ...
           [repmat(2, 3, 1); repmat(0, 3, 1)], ...
           [repmat(2, 3, 1); repmat(1, 3, 1)]];
i = 0; % i = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

header = headers(:, i+1);

messagePartitionSize = length(messageVoice)/partitions;
% frameSize = messagePartitionSize/2;
frameSize = messagePartitionSize;

messagePartition = messageVoice(1 + i*messagePartitionSize:(i+1)*messagePartitionSize);

% message1 = messagePartition(1:frameSize);
% message2 = messagePartition(frameSize + 1:end);

% message = repmat([3; 2; 1; 0;], 250, 1);

rng(1);
message = randi([0 M-1], 1000, 1);

rng(10); filler1 = randi([0 M-1], 200, 1); filler1Mod = pskmod(filler1, M, pi/M, "gray");
rng(20); filler2 = randi([0 M-1], 200, 1); filler2Mod = pskmod(filler2, M, pi/M, "gray");

% bitStream = [message1; preamble; header; message2];
% bitStream = [filler1; preamble; header; messagePartition; filler2];
bitStream = [filler1; preamble; header; message; filler2];

preambleMod = pskmod(preamble, M, pi/M, "gray");
bitStreamMod = pskmod(bitStream, M, pi/M, "gray");

% Setup transmit-signal
txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);