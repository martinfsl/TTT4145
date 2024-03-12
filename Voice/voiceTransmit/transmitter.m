release(tx);

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

partitions = 29;
voiceMessageCut = voiceMessage(1:29000);

messages = reshape(voiceMessageCut, [1000, 29]);

%%% ---------------------------------------------------

%%% ---------------------------------------------------
% Setup txSignal

i = 29;

message = messages(:, i);
header = headers(:, i);

bitStream = [preamble; header; message];
bitStreamMod = pskmod(bitStream, M, pi/M, "gray");

txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);

transmitRepeat(tx, txSignal);

%%% ---------------------------------------------------
