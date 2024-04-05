%%% ---------------------------------------------------
%%% Stry:
%%% ---------------------------------------------------
% Read voice message

% If you want symbols (0, 3)
% [voiceMessage, fs] = setupVoiceFromFile("VoiceFiles/stry(1).wav");
load("voiceFiles/stry.mat");
voiceMessage = s.voiceMessage;
fs = s.fs;

%%% ---------------------------------------------------

%%% ---------------------------------------------------
% Partition the voice signal

partitions = 2;
voiceMessageCut = voiceMessage(1:29000);

messages = reshape(voiceMessageCut, [length(voiceMessageCut)/partitions, partitions]);

% messages = voiceMessages;

%%% ---------------------------------------------------

% %%% ---------------------------------------------------
% %%% Fredrikstad:
% %%% ---------------------------------------------------
% % Read voice message
% 
% % If you want symbols (0, 3)
% % [voiceMessage, fs] = setupVoiceFromFile("VoiceFiles/fredrikstad.wav");
% 
% load("voiceFiles/fredrikstad.mat");
% voiceMessage = s.voiceMessage;
% fs = s.fs;
% 
% %%% ---------------------------------------------------
% 
% %%% ---------------------------------------------------
% % Partition the voice signal
% 
% partitions = 48;
% voiceMessageCut = voiceMessage(1:696000);
% 
% messages = reshape(voiceMessageCut, [length(voiceMessageCut)/partitions, partitions]);
% 
% % messages = voiceMessages;
% 
% %%% ---------------------------------------------------
