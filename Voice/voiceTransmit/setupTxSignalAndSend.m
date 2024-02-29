[message, Fs] = setupVoiceFromFile("stry(1).wav");
% [message, Fs] = setupVoiceFromFile("cranking_1.wav");

message = message(1:29500);

rng(1);
permVector = randperm(length(message));
message = intrlv(message, permVector);

% message1 = message(1:length(message)/2);
% message2 = message(length(message)/2 + 1:end);

messagePartitionSize = length(message)/10;
frameSize = messagePartitionSize/2;

preamble = [2; 2; 1; 1; 0; 0; 2; 2; 2; 1; 1; 1; 3; 3; 3; 0; 0; 0];
preamble = repmat(preamble, 50, 1);

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
           [repmat(2, 3, 1); repmat(1, 3, 1)]];

% Setup pulse modulation filter
rolloff = 0.95;
sps = 20;
span = 200;
rrcFilter = rcosdesign(rolloff, span, sps, "sqrt");

for i = 0:9
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
    % transmitRepeat(tx, txSignal);
    tx(txSignal);

    % 5 sec delay between each new transmission
    pause(4.0);
end