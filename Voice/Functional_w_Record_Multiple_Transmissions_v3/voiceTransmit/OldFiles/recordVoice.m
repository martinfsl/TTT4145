function bittified_audio = recordVoice(frameLength, Fs)

    combined_audio = []; %Just an empty vector
    nBits = 8; %Bit-depth
    % nLevels = 2^nBits;  % Number of quantization levels
    %----------------------------------------------%
    deviceReader = audioDeviceReader( ...
        Fs, ...
        'BitDepth','16-bit integer', ...
        'SamplesPerFrame', frameLength, ...
        'Device','Default');
    setup(deviceReader)
    %sets up the system Object that samples audio from the microphone
    %----------------------------------------------%
    
    %----------------------------------------------%
    disp("Start talking");
    %Where the magic happens
    tic
    while toc<3
        aquiredAudio = deviceReader();  
        
        combined_audio = [combined_audio; aquiredAudio];
    end
    disp("Finished recording");
    quantized_audio = quantize_signal(combined_audio);
    bittified_audio = int2bit(quantized_audio, nBits);

    % step()
    %------------------------------------------------%
    %Plots n' Shit
    
    % subplot(2,1,1);
    % plot(combined_audio)
    % subplot(2,1,2);
    % plot(quantized_audio)
    % subplot(3,1,3);
    % plot(bittified_audio)
    
    %-------------------------------------------------%
    %Releases the system Object from it's shackles
    release(deviceReader)
    % release(deviceWriter)
end
   
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

