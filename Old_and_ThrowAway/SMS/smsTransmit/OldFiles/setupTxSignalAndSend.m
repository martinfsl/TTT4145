[message, Fs] = setupVoiceFromFile("stry(1).wav");
% [message, Fs] = setupVoiceFromFile("cranking_1.wav");

message = message(1:29500);
% message = message(1:29600);

rng(1);
permVector = randperm(length(message));
message = intrlv(message, permVector);

% message1 = message(1:length(message)/2);
% message2 = message(length(message)/2 + 1:end);

run setupTx.m

messagePartitionSize = length(message)/partitions;
frameSize = messagePartitionSize/2;

M = 4;
preambleMod = pskmod(preamble, M, pi/M, "gray");

headers = [[repmat(0, 3, 1); repmat(0, 3, 1)], ...
           [repmat(0, 3, 1); repmat(1, 3, 1)], ...
           [repmat(0, 3, 1); repmat(2, 3, 1)], ...
           [repmat(0, 3, 1); repmat(3, 3, 1)], ...
           [repmat(1, 3, 1); repmat(0, 3, 1)], ...
           [repmat(1, 3, 1); repmat(1, 3, 1)], ...
           [repmat(1, 3, 1); repmat(2, 3, 1)], ...
           [repmat(1, 3, 1); repmat(3, 3, 1)], ...
           [repmat(2, 3, 1); repmat(0, 3, 1)], ...
           [repmat(2, 3, 1); repmat(1, 3, 1)], ...
           [repmat(2, 3, 1); repmat(2, 3, 1)], ...
           [repmat(2, 3, 1); repmat(3, 3, 1)], ...
           [repmat(3, 3, 1); repmat(0, 3, 1)], ...
           [repmat(3, 3, 1); repmat(1, 3, 1)], ...
           [repmat(3, 3, 1); repmat(2, 3, 1)], ...
           [repmat(3, 3, 1); repmat(3, 3, 1)]];

for i = 0:(partitions-1)
    % i = 3; % i = [0, 1, 2, 3]
    messagePartition = message(1 + i*messagePartitionSize:(i+1)*messagePartitionSize);
    
    message1 = messagePartition(1:frameSize);
    message2 = messagePartition(frameSize + 1:end);
    
    % header = [i; i; i;];
    header = headers(:, i+1);
    
    bitStream = [message1; preamble; header; message2];
    
    M = 4;
    
    bitStreamMod = pskmod(bitStream, M, pi/M, "gray");
    
    % Setup transmit-signal
    txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);

    fprintf("%s %i \n", "Transmission: ", i+1);
    transmitRepeat(tx, txSignal);
    % tx(txSignal);
    % pause(0.4);
    % tx(txSignal);

    % sec delay between each new transmission
    pause(2);
end