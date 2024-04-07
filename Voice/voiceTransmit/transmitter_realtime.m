messagesRepeated = repmat(messages, 1, 2);

bulkSize = 3;
numTransmissions = floor(size(messagesRepeated, 2)/bulkSize);

%%% ---------------------------------------------------
% Start by sending some junk for some time:
rng(526);
junk = randi([0 M-1], 2*fillerSize + bulkSize*(length(preamble)+size(headers, 1)+frameSize), 1);
junkMod = pskmod(junk, M, pi/M, "gray");

transmitRepeat(tx, upfirdn(junkMod, rrcFilter, sps, 1));
pause(2);
%%% ---------------------------------------------------

messagesToSend = messagesRepeated;
headersSent = [];

disp("Starting transmission");

j = 1;
for t = 1:numTransmissions
    tic

    bitStream = [];

    bitStream = [bitStream; zeros(fillerSize, 1)];
    
    for i = 1:bulkSize
        if j == 33
            j = 1;
        end

        header = headers(:, j);
        headersSent = [headersSent, j-1];

        message = messagesToSend(:, i);

        j = j + 1;

        bitStream = [bitStream; preamble; header; message];
    end
    
    messagesToSend = messagesToSend(:, bulkSize+1:end);

    bitStream = [bitStream; zeros(fillerSize, 1)];

    bitStreamMod = pskmod(bitStream, M, pi/M, "gray");
    
    txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);

    fprintf("%s %i \n", "Transmitting packet nr. ", t);

    transmitRepeat(tx, txSignal);

    toc

    % pause(0.3);
    % pause(1);
    pause(0.4);
end

disp("Finished transmission");

release(tx);

% bitStream = [];
% k = 1; j = 1;
% headersSent = [];
% for i = 1:size(messages, 2)
%     if k == (size(messages, 2) + 1)
%         k = 1;
%     end
%     if j == 33
%         j = 1;
%     end
% 
%     message = messages(:, k);
%     header = headers(:, j);
% 
%     headersSent = [headersSent, header];
% 
%     k = k + 1; j = j + 1;
% 
%     bitStream = [bitStream; preamble; header; message];
% end
% 
% bitStreamMod = pskmod(bitStream, M, pi/M, "gray");
% 
% txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);
% 
% tic
% disp("Transmitting the signal");
% 
% transmitRepeat(tx, txSignal);
