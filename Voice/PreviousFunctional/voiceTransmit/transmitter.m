% release(tx);

%%% ---------------------------------------------------
rng(630);

% init = [zeros(200, 1); zeros(52, 1); zeros(9, 1); zeros(1000, 1); zeros(200, 1)];
% initMod = pskmod(init, M, pi/M, "gray");
% txSignal = upfirdn(initMod, rrcFilter, sps, 1);
% tx(txSignal);

% Iterate through and send all messages
k = 1;
j = 1;
for i = 1:100*size(messages, 2)
    tic

    if k == (size(messages, 2) + 1)
        k = 1;
    end
    if j == 33
        j = 1;
    end

    message = messages(:, k);
    header = headers(:, j);

    k = k + 1; j = j + 1;

    filler = randi([0 M-1], fillerSize*2, 1);

    % bitStream = [filler(1:200); preamble; header; message; filler(201:end)];
    bitStream = [preamble; header; message;];
    bitStreamMod = pskmod(bitStream, M, pi/M, "gray");

    txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);

    transmitRepeat(tx, txSignal);
    % tx(txSignal);

    fprintf("%s %i \n", "Transmitting: ", i);

    % pause(0.185);

    % pause(0.5);
    pause(0.3);
    % pause(0.4);

    % if i == 1
    %     pause(0.4);
    % else
    %     % pause(0.1);
    %     % pause(0.065);
    %     % pause(0.3);
    %     % pause(0.06);
    %     pause(0.5);
    % end

    toc
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
% bitStream = [preamble; header; message;];
% bitStreamMod = pskmod(bitStream, M, pi/M, "gray");
% 
% txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);
% 
% transmitRepeat(tx, txSignal);
% tx(txSignal);
% release(tx);

%%% ---------------------------------------------------
