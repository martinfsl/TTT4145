fs = 16e3; 
numChannels = 1; 
% frameSize = 2^8;

audioFrameSize = 2900/4;

audioInput = audioDeviceReader('SampleRate', fs, 'NumChannels', numChannels, 'SamplesPerFrame', audioFrameSize);

figure;
plotHandle = plot(zeros(frameSize,1)); 
xlabel('Time (s)');
ylabel('Amplitude');
ylim([-1 4]);
title('Real-time Audio Input');

% Read audio data from the input device
audioData = audioInput();

% Signal processing
% q_audioData = quantize_signal(audioData);
% processedData = processed(audioData);

set(plotHandle, 'YData', audioData);
drawnow;

function voiceMessage = processData(y)
    y_scaled = ((y+1)/2)*255;
    
    nBits = 8;
    nLevels = 2^nBits;  % Number of quantization levels
    y_quantized = uint8(round(y_scaled));
    
    y_bits = int2bit(y_quantized, nBits);
    
    nSymbols = length(y_bits)/2;
    voiceMessage = zeros(nSymbols, 1);
    
    for i = 1:nSymbols
        bits = y_bits((i-1)*2 + 1 : i*2);
        voiceMessage(i) = bit2int(bits, 2);
    end
end