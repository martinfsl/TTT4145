[messageVoice, Fs] = setupVoiceFromFile("VoiceFiles/stry(1).wav");
% [message, Fs] = setupVoiceFromFile("cranking_1.wav");

messageVoice = messageVoice(1:29500);

run setupTx.m

i = 5; % i = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

header = headers(:, i+1);

messagePartitionSize = length(messageVoice)/partitions;
frameSize = messagePartitionSize;

% messagePartition = messageVoice(1 + i*messagePartitionSize:(i+1)*messagePartitionSize);

rng(1); message = randi([0 M-1], 1000, 1);
rng(10); filler = randi([0 M-1], 400, 1); filler1Mod = pskmod(filler, M, pi/M, "gray");

bitStream = [filler(1:100); preamble; header; message; filler(101:end)];

preambleMod = pskmod(preamble, M, pi/M, "gray");
bitStreamMod = pskmod(bitStream, M, pi/M, "gray");

% Setup transmit-signal
txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);