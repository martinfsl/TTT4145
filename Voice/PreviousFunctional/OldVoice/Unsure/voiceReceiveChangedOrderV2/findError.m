Current_Dir = pwd;
TransmitPath = '../voiceTransmit';

cd(TransmitPath);
[trueMessage, ~] = setupVoiceFromFile("stry(1).wav");
cd(Current_Dir);

trueMessage = trueMessage(1:29500);

% Testing interleaving
rng(1);
permVector = randperm(length(voiceMessage));
% voiceMessage = intrlv(voiceMessage, permVector);
voiceMessageDeinterleaved = deintrlv(voiceMessage, permVector);

trueMessageInterleaved = intrlv(trueMessage, permVector);

errorInterleaved = sum(voiceMessage ~= trueMessageInterleaved);
error_Pb_Interleaved = errorInterleaved/length(voiceMessage);
errorDiff_Interleaved = zeros(length(allReceivedHeaders), 1);

for i = 1:length(allReceivedHeaders)
    startIndex = (i-1)*(2*frameSize - 1) + 1;
    endIndex = i*(2*frameSize);
    errorDiff_Interleaved(i, 1) = sum(...
        voiceMessage(startIndex:endIndex) ~= ...
        trueMessageInterleaved(startIndex:endIndex));
end

errorDeinterleaved = sum(voiceMessageDeinterleaved ~= trueMessage);
error_Pb_Deinterleaved = errorDeinterleaved/length(voiceMessage);
errorDiff_Deinterleaved = zeros(length(allReceivedHeaders), 1);

for i = 1:length(allReceivedHeaders)
    startIndex = (i-1)*(2*frameSize - 1) + 1;
    endIndex = i*(2*frameSize);
    errorDiff_Deinterleaved(i, 1) = sum(...
        voiceMessageDeinterleaved(startIndex:endIndex) ~= ...
        trueMessage(startIndex:endIndex));
end