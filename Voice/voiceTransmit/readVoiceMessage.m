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
