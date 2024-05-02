fs = 16e3;
% fs = 48e3;
numChannels = 1; 
% frameSize = 2^8;

frameSize = 3000;
amountOfFrames = 100;

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
    processedData = audioDataToSymbols(audioData);
    voiceMessages = [voiceMessages, processedData];

    set(plotHandle, 'YData', audioData);
    drawnow;

    amount = amount + 1;
    disp(amount);
end
release(audioInput);

% Construct a signal to send
messages = voiceMessages;

bitStream = [];
k = 1; j = 1;
headersSent = [];
for i = 1:size(messages, 2)
    if k == (size(messages, 2) + 1)
        k = 1;
    end
    if j == 33
        j = 1;
    end

    message = messages(:, k);
    header = headers(:, j);

    headersSent = [headersSent, j-1];

    k = k + 1; j = j + 1;

    bitStream = [bitStream; preamble; header; message];
end

bitStreamMod = pskmod(bitStream, M, pi/M, "gray");

txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);

tic
disp("Transmitting the signal");

transmitRepeat(tx, txSignal);

% pause(10);

% release(tx);

% audioDataToPlay = symbolsToAudioData(voiceMessages(:), length(allAudioData(:)));


% Functions to convert to symbols and back
function symbols = audioDataToSymbols(audioData)
    % Parameters
    nBits = 8; % Number of bits for quantization
    nLevels = 2^nBits; % Number of quantization levels
    
    % Quantize audio data
    % Map from [-1, 1] to [0, nLevels-1]
    quantizedData = uint8(((audioData + 1) / 2) * (nLevels - 1));
    
    % Initialize symbols array
    % Each quantized sample will be represented by a sequence of 4 symbols based on your definition
    symbols = zeros(length(quantizedData) * 4, 1);
    
    % Convert quantized data to symbols
    for i = 1:length(quantizedData)
        % Extract bits from the quantized data
        bits = bitget(quantizedData(i), 8:-1:1);
        
        % For simplicity, let's map the first two bits of each sample to a symbol
        % This is a demonstrative approach and will result in loss of information
        % since we're not using the full byte
        symbolIndex = (i-1)*4 + 1;
        symbols(symbolIndex:symbolIndex+3) = [bits(1)*2 + bits(2), bits(3)*2 + bits(4), bits(5)*2 + bits(6), bits(7)*2 + bits(8)];
    end
end

function audioData = symbolsToAudioData(symbols, nSamples)
    % Parameters
    nBits = 8; % Number of bits for quantization
    nLevels = 2^nBits; % Number of quantization levels
    
    % Initialize the array for quantized values
    quantizedData = zeros(nSamples, 1);
    
    % Convert symbols back to quantized values
    for i = 1:nSamples
        symbolIndex = (i-1)*4 + 1;
        bits = [symbols(symbolIndex), symbols(symbolIndex+1), symbols(symbolIndex+2), symbols(symbolIndex+3)];
        
        % Reconstruct the byte from the symbols
        byte = 0;
        for j = 1:4
            byte = byte + bitshift(bits(j), (4-j)*2);
        end
        
        quantizedData(i) = byte;
    end
    
    % Dequantize
    % Map from [0, nLevels-1] back to [-1, 1]
    audioData = double(quantizedData) / (nLevels - 1) * 2 - 1;
end
