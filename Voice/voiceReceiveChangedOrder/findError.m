Current_Dir = pwd;
TransmitPath = '../voiceTransmit';

cd(TransmitPath);
[trueMessage, ~] = setupVoiceFromFile("stry(1).wav");
cd(Current_Dir);

error = sum(voiceMessage ~= trueMessage);
error_Pb = error/length(voiceMessage);

% errorDiff = (voiceMessage ~= trueMessage);
errorDiff = zeros(length(allReceivedHeaders), 1);

for i = 1:length(allReceivedHeaders)
    startIndex = (i-1)*(2*frameSize - 1) + 1;
    endIndex = i*(2*frameSize);
    errorDiff(i, 1) = sum(...
        voiceMessage(startIndex:endIndex) ~= ...
        trueMessage(startIndex:endIndex));
end