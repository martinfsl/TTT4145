Current_Dir = pwd;
TransmitPath = '../voiceTransmit';

cd(TransmitPath);
[trueMessage, ~] = setupVoiceFromFile("stry(1).wav");
cd(Current_Dir);

trueMessage = trueMessage(1:29000);
messages = reshape(trueMessage, [1000, 29]);

errors = [];
for k = 1:size(messages, 2)
    errors = [errors, symerr(decodedMessage, messages(:, k))];
end