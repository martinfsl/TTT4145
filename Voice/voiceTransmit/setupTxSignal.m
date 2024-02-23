[message, Fs] = setupVoiceFromFile("stry(1).wav");
% [message, Fs] = setupVoiceFromFile("cranking_1.wav");

% message1 = message(1:length(message)/2);
% message2 = message(length(message)/2 + 1:end);

messagePartitionSize = length(message)/4;
frameSize = messagePartitionSize/2;

preamble = [2; 2; 1; 1; 0; 0; 2; 2; 2; 1; 1; 1; 3; 3; 3; 0; 0; 0];
preamble = repmat(preamble, 50, 1);

% messagePutTogether = [];
% for i = 0:3
%     messagePartition = message(1 + i*messagePartitionSize:(i+1)*messagePartitionSize);
%     messagePutTogether = [messagePutTogether; messagePartition];
% end

i = 3; % i = [0, 1, 2, 3]
messagePartition = message(1 + i*messagePartitionSize:(i+1)*messagePartitionSize);

message1 = messagePartition(1:frameSize);
message2 = messagePartition(frameSize + 1:end);

bitStream = [message1; preamble; message2];