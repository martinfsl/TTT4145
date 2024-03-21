% release(tx);

%%% ---------------------------------------------------
% Read voice message

% If you want symbols (0, 3)
[voiceMessage, fs] = setupVoiceFromFile("VoiceFiles/stry(1).wav");

% If you want bits
% [voiceMessageBits, fs] = setupVoiceFromFileBits("VoiceFiles/stry(1).wav");
% voiceMessageBitsMod = pskmod(voiceMessageBits, M, pi/M, "gray", InputType = 'bit');

%%% ---------------------------------------------------

%%% ---------------------------------------------------
% Partition the voice signal

partitions = 10;
voiceMessageCut = voiceMessage(1:29000);

messages = reshape(voiceMessageCut, [length(voiceMessageCut)/partitions, partitions]);

% messages = voiceMessages;

%%% ---------------------------------------------------

%%% ---------------------------------------------------
rng(630);

% init = [zeros(200, 1); zeros(52, 1); zeros(9, 1); zeros(1000, 1); zeros(200, 1)];
% initMod = pskmod(init, M, pi/M, "gray");
% txSignal = upfirdn(initMod, rrcFilter, sps, 1);
% tx(txSignal);

% Iterate through and send all messages
% k = 1;
% j = 1;
% for i = 1:size(messages, 2)
% 
%     if k == (size(messages, 2) + 1)
%         k = 1;
%     end
%     if j == 33
%         j = 1;
%     end
% 
%     message = messages(:, k);
%     header = headers(:, j);
% 
%     k = k + 1; j = j + 1;
% 
%     filler = randi([0 M-1], fillerSize*2, 1);
% 
%     % bitStream = [filler(1:200); preamble; header; message; filler(201:end)];
%     bitStream = [preamble; header; message;];
%     bitStreamMod = pskmod(bitStream, M, pi/M, "gray");
% 
%     txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);
% 
%     tic
% 
%     transmitRepeat(tx, txSignal);
%     % tx(txSignal);
% 
%     toc
% 
%     fprintf("%s %i \n", "Transmitting: ", i);
% 
%     % pause(0.185);
%     pause(0.04);
% end
% release(tx);

%%% ---------------------------------------------------

%%% ---------------------------------------------------

% Continously send one signal
i = 5;

message = messages(:, i);
header = headers(:, i);

filler = randi([0 M-1], fillerSize*2, 1);

bitStream = [preamble; header; message;];
bitStreamMod = pskmod(bitStream, M, pi/M, "gray");

txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);

transmitRepeat(tx, txSignal);
% tx(txSignal);
% release(tx);

%%% ---------------------------------------------------
