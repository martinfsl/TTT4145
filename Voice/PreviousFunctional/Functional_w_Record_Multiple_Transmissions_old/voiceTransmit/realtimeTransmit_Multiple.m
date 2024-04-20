fs = 16e3;
% fs = 48e3;
numChannels = 1; 
% frameSize = 2^8;

% frameSize = 3000;
% global amountOfFrames
% amountOfFrames = 100;

run transmitJunk.m

pause(0.4);

% amountOfFrames = 300;

global voiceMessagesToSend
voiceMessagesToSend = [];

global bulk_control
bulk_control = [];

global bulk_headers_sent
bulk_headers_sent = [];

audioInput = audioDeviceReader('SampleRate', fs, 'NumChannels', numChannels, 'SamplesPerFrame', frameSize/4);

symbolTime = 1.1e-5; % sps / sampleRate
% totalTime = symbolTime*(length(preamble) + size(bulk_headers, 1) + size(headers, 1) + frameSize)*amountOfFrames;
totalTime = 3.3;

% playbackTime = totalTime - 0.05;
playbackTime = totalTime + 0.1;

% playbackTime = totalTime - 0.3;
% playbackTime = 2.5;

% pause(ceil(totalTime));

playTimer = timer('ExecutionMode', 'fixedRate', ...
    'Period', playbackTime, ...
    'TimerFcn', ...
        @(~, ~)transmitNextChunk(headers, preamble, rrcFilter, sps, M));

figure;
plotHandle = plot(zeros(frameSize,1)); 
xlabel('Time (s)');
ylabel('Amplitude');
% ylim([-1 4]);
ylim([-1 1]);
title('Real-time Audio Input');

l = 1;

temp = 0;
while temp < 20
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
        % disp(amount);
    end
    % release(audioInput);
    
    % Construct a signal to send
    % messages = voiceMessages;
    voiceMessagesToSend = [voiceMessagesToSend, voiceMessages];
    
    if l == 17
        l = 1;
    end

    bulk_control = [bulk_control, bulk_headers(:, l)];

    l = l + 1;

    % Starting the timer that regularly transmits the data
    if temp == 1
        start(playTimer);
    end

    fprintf("%s %i \n", "Finished recording bulk:", temp+1);
    
    temp = temp + 1;
end

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
