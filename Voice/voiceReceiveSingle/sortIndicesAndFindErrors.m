% [sortHeaders1, sortIdx1] = sort(allHeaders(1:29), "ascend");
% [sortHeaders2, sortIdx2] = sort(allHeaders(30:end), "ascend");
% 
% sortHeaders = [sortHeaders1; sortHeaders2];
% sortIdx = [sortIdx1; sortIdx2+29];

[sortHeaders, sortIdx] = sort(allHeaders, "ascend");

Current_Dir = pwd;
TransmitPath = '../voiceTransmit';

cd(TransmitPath);
[trueMessage, ~] = setupVoiceFromFile("VoiceFiles/stry(1).wav");
cd(Current_Dir);

trueMessage = trueMessage(1:29000);
% trueMessage = repmat(trueMessage, 2, 1);
messages = reshape(trueMessage, [frameSize, length(trueMessage)/frameSize]);

errorsSorted = [];

for i = 1:length(sortHeaders)
    errorsSorted = [errorsSorted, symerr(allMessages(:, sortIdx(i)), messages(:, i))];
end

errors_total = sum(errorsSorted);
errors_pb = errors_total/length(trueMessage);
