% frameLength = 320; Fs = 16000;

% symbols = recordVoice(frameLength, Fs);
[message, Fs] = setupVoiceFromFile("stry(1).wav");
% [message, Fs, y] = setupVoiceFromFileBits("stry(1).wav");