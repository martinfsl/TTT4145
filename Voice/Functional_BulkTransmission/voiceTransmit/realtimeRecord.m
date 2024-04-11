fs = 16e3;
% fs = 48e3;
numChannels = 1; 
% frameSize = 2^8;

frameSize = 3000;
amountOfFrames = 50;

audioInput = audioDeviceReader('SampleRate', fs, 'NumChannels', numChannels, 'SamplesPerFrame', frameSize/4);

figure;
plotHandle = plot(zeros(frameSize,1)); 
xlabel('Time (s)');
ylabel('Amplitude');
% ylim([-1 4]);
ylim([-1 1]);
title('Real-time Audio Input');

allAudioData = [];
voiceMessages = [];

% Process real-time audio
amount = 0;
% while true
while amount < amountOfFrames
    % Read audio data from the input device
    audioData = audioInput();

    allAudioData = [allAudioData, audioData];

    % Signal processing
    % q_audioData = quantize_signal(audioData);
    processedData = processData(audioData);

    voiceMessages = [voiceMessages, processedData];

    set(plotHandle, 'YData', audioData);
    drawnow;

    amount = amount + 1;
    disp(amount);
end
release(audioInput);

reconstructedVoice = reconstructVoiceSignal(voiceMessages(:));

function voiceMessage = processData(y)
    if mod(length(y), 2)
        y = y(1:end-1);
    end
    
    nBits = 8;
    nLevels = 2^nBits;  % Number of quantization levels
    y_quantized = uint8(round((y + 1) * (nLevels/2 - 1)));
    
    y_bits = int2bit(y_quantized, nBits);
    
    nSymbols = length(y_bits)/2;
    voiceMessage = zeros(nSymbols, 1);

    for i = 1:nSymbols
        bits = y_bits((i-1)*2 + 1 : i*2);

        if size(bits, 1) == 1
            voiceMessage(i) = bit2int(bits', 2);
        else
            voiceMessage(i) = bit2int(bits, 2);
        end
    end
end