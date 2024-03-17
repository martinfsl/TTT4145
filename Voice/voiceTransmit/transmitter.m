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
for i = 1:size(messages, 2)
% for i = 1:64
    % i = 23;

    if i <= 32
        j = i;
    elseif i > 32
        j = i-32;
    end

    message = messages(:, i);
    header = headers(:, j);

    filler = randi([0 M-1], fillerSize*2, 1);

    bitStream = [filler(1:200); preamble; header; message; filler(201:end)];
    bitStreamMod = pskmod(bitStream, M, pi/M, "gray");

    txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);

    transmitRepeat(tx, txSignal);
    % tx(txSignal);

    fprintf("%s %i \n", "Transmitting: ", i);

    pause(0.185);
end
release(tx);

%%% ---------------------------------------------------

%%% ---------------------------------------------------

% Continously send one signal
% i = 5;
% 
% message = messages(:, i);
% header = headers(:, i);
% 
% filler = randi([0 M-1], fillerSize*2, 1);
% 
% bitStream = [filler(1:200); preamble; header; message; filler(201:end)];
% bitStreamMod = pskmod(bitStream, M, pi/M, "gray");
% 
% txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);
% 
% transmitRepeat(tx, txSignal);
% tx(txSignal);
% release(tx);

%%% ---------------------------------------------------
