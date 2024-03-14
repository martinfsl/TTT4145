Current_Dir = pwd;
TransmitPath = '../voiceTransmit';

cd(TransmitPath);
[trueMessage, ~] = setupVoiceFromFile("VoiceFiles/stry(1).wav");
cd(Current_Dir);

trueMessage = trueMessage(1:29000);
messages = reshape(trueMessage, [1000, 29]);

errors = zeros(size(allMessages, 2), size(messages, 2));
for k = 1:size(messages, 2)
    for l = 1:size(allMessages, 2)
        errors(l, k) = symerr(allMessages(:, l), messages(:, k));
    end
end