Current_Dir = pwd;
TransmitPath = '../voiceTransmit';

cd(TransmitPath);
[trueMessage, ~] = setupVoiceFromFile("stry(1).wav");
cd(Current_Dir);

error = sum(voiceMessage ~= trueMessage);
error_Pb = error/length(voiceMessage);

errorDiff = (voiceMessage ~= trueMessage);