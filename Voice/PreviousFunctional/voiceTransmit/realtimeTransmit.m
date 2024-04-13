fs = 16e3; 
numChannels = 1; 
% frameSize = 2^8;

frameSize = 2900;

audioInput = audioDeviceReader('SampleRate', fs, 'NumChannels', numChannels, 'SamplesPerFrame', frameSize/4);

% figure;
% plotHandle = plot(zeros(frameSize,1)); 
% xlabel('Time (s)');
% ylabel('Amplitude');
% % ylim([-1 4]);
% ylim([-1, 1]);
% title('Real-time Audio Input');

voiceMessages = [];

k = 1;

% Process real-time audio
amount = 0;
% while true
while amount < 100

    tic

    % Read audio data from the input device
    audioData = audioInput();

    % Signal processing
    % q_audioData = quantize_signal(audioData);
    processedData = processVoice(audioData);

    voiceMessages = [voiceMessages, processedData];

    if k == 33
        k = 1;
    end

    bitStream = modulateVoice(processedData, ...
        headers, fillerSize, preamble, k, M);

    bitStreamMod = pskmod(bitStream, M, pi/M, "gray");

    txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);
    
    transmitRepeat(tx, txSignal);

    pause(0.5);

    % set(plotHandle, 'YData', audioData);
    % drawnow;

    amount = amount + 1;
    disp(amount);

    toc
end
release(audioInput);

release(tx);