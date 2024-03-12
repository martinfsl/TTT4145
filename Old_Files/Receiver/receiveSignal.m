% Run setupReceiver.m before running this script
% run setupReceiver.m;

% rxSignal = rx();

% i = 0;
% 
% while i < 10
%     rxSignal = capture(rx, numSamples);
%     run("rxAnalyzePreMid");
%     pause(5);
%     i = i+1;
% end

rxSignal = capture(rx, numSamples);