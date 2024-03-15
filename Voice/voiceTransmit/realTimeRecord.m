clear; close; clc;

fs = 16e3; 
numChannels = 1; 
frameSize = 2^8;

audioInput = audioDeviceReader('SampleRate', fs, 'NumChannels', numChannels, 'SamplesPerFrame', frameSize);

figure;
plotHandle = plot(zeros(frameSize,1)); 
xlabel('Time (s)');
ylabel('Amplitude');
ylim([0 frameSize-1])
title('Real-time Audio Input');

% Process real-time audio
while true
    % Read audio data from the input device
    audioData = audioInput();

    % Signal processing
    q_audioData = quantize_signal(audioData);
    

    set(plotHandle, 'YData', processedData);
    drawnow;
end
release(audioInput);

function quantized_signal = quantize_signal(signal)
    nBits = 8;
    B = nBits - 1;
    step_size = 2^(-B);
    quantized_signal = round((signal + 1)/step_size);
    %quantized_signal = step_size*floor((signal + 1)/2);
end
