[message, Fs] = setupVoiceFromFile("stry(1).wav");
% [message, Fs] = setupVoiceFromFile("cranking_1.wav");

% message1 = message(1:length(message)/2);
% message2 = message(length(message)/2 + 1:end);

messagePartitionSize = length(message)/4;
frameSize = messagePartitionSize/2;

preamble = [2; 2; 1; 1; 0; 0; 2; 2; 2; 1; 1; 1; 3; 3; 3; 0; 0; 0];
% preamble = repmat(preamble, 50, 1);
preamble = repmat(preamble, 10, 1);

% messagePutTogether = [];
% for i = 0:3
%     messagePartition = message(1 + i*messagePartitionSize:(i+1)*messagePartitionSize);
%     messagePutTogether = [messagePutTogether; messagePartition];
% end

i = 3; % i = [0, 1, 2, 3]
messagePartition = message(1 + i*messagePartitionSize:(i+1)*messagePartitionSize);

message1 = messagePartition(1:frameSize);
message2 = messagePartition(frameSize + 1:end);

header = [i; i; i;];
% header = [5; 5; 5;];

% bitStream = [message1; preamble; header; message2];

message1 = repmat([3; 2; 1; 0;], 20, 1);
message2 = repmat([0; 1; 2; 3;], 20, 1);
bitStream = [message1; preamble; header; message2;];
frameSize = 80;

M = 4;

preambleMod = pskmod(preamble, M, pi/M, "gray");
bitStreamMod = pskmod(bitStream, M, pi/M, "gray");

% Setup pulse modulation filter
rolloff = 0.6;
sps = 20;
span = 200;
rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");

% Setup transmit-signal
txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);