% %%% ---------------------------------------------------
% %%% Stry:
% %%% ---------------------------------------------------
% % Read voice message
% 
% % If you want symbols (0, 3)
% % [voiceMessage, fs] = setupVoiceFromFile("VoiceFiles/stry(1).wav");
% load("voiceFiles/stry.mat");
% voiceMessage = s.voiceMessage;
% fs = s.fs;
% 
% %%% ---------------------------------------------------
% 
% %%% ---------------------------------------------------
% % Partition the voice signal
% 
% partitions = 5;
% voiceMessageCut = voiceMessage(1:29000);
% 
% messages = reshape(voiceMessageCut, [length(voiceMessageCut)/partitions, partitions]);
% 
% % messages = voiceMessages;
% 
% %%% ---------------------------------------------------

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
% partitions = 121;
% voiceMessageCut = voiceMessage(1:701800);
% 
% messages = reshape(voiceMessageCut, [length(voiceMessageCut)/partitions, partitions]);
% 
% % messages = voiceMessages;
% 
% %%% ---------------------------------------------------

%%% ---------------------------------------------------
%%% Fredrikstad resampled:
%%% ---------------------------------------------------
% Read voice message

% If you want symbols (0, 3)
% [voiceMessage, fs] = setupVoiceFromFile("VoiceFiles/fredrikstad_resampled.wav");

load("voiceFiles/fredrikstad_resampled.mat");
voiceMessage = s.voiceMessage;
fs = s.fs;

%%% ---------------------------------------------------

%%% ---------------------------------------------------
% Partition the voice signal

% partitions = 65;
% voiceMessageCut = voiceMessage(1:377000);

% partitions = 48;
% voiceMessageCut = voiceMessage;

partitions = 128;
voiceMessageCut = voiceMessage;

messages = reshape(voiceMessageCut, [length(voiceMessageCut)/partitions, partitions]);

% messages = voiceMessages;

%%% ---------------------------------------------------