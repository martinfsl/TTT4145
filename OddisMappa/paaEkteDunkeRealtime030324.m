tic;
samplesPerFrame = 320; % 20ms
Fs = 16000; % Sample Frequency
numberOfFrames = 250;

nBits = 8; %Bit-depth
% tiktok = (samplesPerFrame/Fs)*numberOfFrames;
% nLevels = 2^nBits;  % Number of quantization levels
%----------------------------------------------%
deviceReader = audioDeviceReader( ...
    Fs, ...
    'BitDepth','16-bit integer', ...
    'SamplesPerFrame', samplesPerFrame, ...
    'Device','Default');
setup(deviceReader)
%sets up the system Object that samples audio from the microphone
%----------------------------------------------%

%----------------------------------------------%
%Where the magic happens
% tic
total_matrix = [];
symbolNumbers = zeros(samplesPerFrame,1);
symbolNumbers(:) = -1;

% while toc < tiktok
for i = 1:numberOfFrames % Added for-loop since in this test we know our wanted number of frames
    aquiredAudio = deviceReader();  
   
    quantized_audio = quantize_signal(aquiredAudio);
    bittified_audio = int2bit(quantized_audio, nBits);

    reshaped_bittified_matrix = reshape(bittified_audio, 2, []);
    reshaped_bittified_matrix = reshaped_bittified_matrix';
    
    for j=1:size(reshaped_bittified_matrix)
        symbolNumbers(j) = reshaped_bittified_matrix(j,1)*2 + reshaped_bittified_matrix(j,2);
        % symbolNumbers(j) = bin2dec(int2str(reshaped_matrix(j,:)));

    end
    
    total_matrix = [total_matrix symbolNumbers];
end

% step()
%------------------------------------------------%
%Plots n' Shit

% subplot(2,1,1);
% plot(combined_audio)
% subplot(2,1,2);
% plot(quantized_audio)
% % subplot(3,1,3);
% plot(bittified_audio)

%-------------------------------------------------%
%Releases the system Object from it's shackles
toc
release(deviceReader)
% release(deviceWriter)
%-------------------------------------------------%
function quantized_signal = quantize_signal(signal)
    % Define number of quantization levels
    num_levels = 256;
    
    % Quantization step size
    step_size = 2 / (num_levels - 1);
    
    % Map signal values to quantization levels
    quantized_signal = round((signal + 1) / step_size);
    
    % Ensure quantized values are within [0, 255] range
    quantized_signal(quantized_signal < 0) = 0;
    quantized_signal(quantized_signal > 255) = 255;
end