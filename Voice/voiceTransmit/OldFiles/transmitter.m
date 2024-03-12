%%% -----------------------------------------------------------------------
% Setup the parameters, preamble, headers etc.

partitions = 5;

% preamble = [2; 2; 1; 1; 0; 0; 2; 2; 2; 1; 1; 1; 3; 3; 3; 0; 0; 0];
% preamble = repmat(preamble, 50, 1);
% preamble = repmat(preamble, 50, 1);

preamble1 = [1; 1; 1; 1; 1; 0; 0; 1; 1; 0; 1; 0; 1;]; % Barker code
preamble2 = [3; 3; 3; 3; 3; 2; 2; 3; 3; 2; 3; 2; 3;];
preamble3 = flip(preamble1);
preamble4 = flip(preamble2);

preamble = [preamble1; preamble2; preamble3; preamble4];

M = 4;

headers = [[repmat(0, 3, 1); repmat(0, 3, 1)], ...
           [repmat(0, 3, 1); repmat(1, 3, 1)], ...
           [repmat(0, 3, 1); repmat(2, 3, 1)], ...
           [repmat(0, 3, 1); repmat(3, 3, 1)], ...
           [repmat(1, 3, 1); repmat(0, 3, 1)], ...
           [repmat(1, 3, 1); repmat(1, 3, 1)], ...
           [repmat(1, 3, 1); repmat(2, 3, 1)], ...
           [repmat(1, 3, 1); repmat(3, 3, 1)], ...
           [repmat(2, 3, 1); repmat(0, 3, 1)], ...
           [repmat(2, 3, 1); repmat(1, 3, 1)]];
%%% -----------------------------------------------------------------------

frameSize = 1000;

rng(1); message1 = randi([0 M-1], frameSize, 1);
rng(2); message2 = randi([0 M-1], frameSize, 1);
messages = [message1, message2];

rng(10); filler = randi([0 M-1], 400, 1);

for i = 1:2
    bitStream = [filler(1:200); preamble; headers(:, i); messages(:, i); filler(201:end)];
    bitStreamMod = pskmod(bitStream, M, pi/M, "gray");

    txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);

    tx(txSignal);
    % transmitRepeat(tx, txSignal);
    % pause(0.02);
    release(tx);
end
