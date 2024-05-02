allHeadersSent = [];

% Setting up junk as filler
rng(9982);
junkSize = amountOfFrames*(length(preamble) + size(bulk_headers, 1) + ...
                           size(headers, 1) + frameSize);
junk = randi([0 M-1], junkSize, 1);

audioInput = audioDeviceReader('SampleRate', 11200, 'NumChannels', 1, ...
                               'SamplesPerFrame', amountOfFrames*frameSize/4);

symbolTime = 1.1e-5; % sps / sampleRate

l = 1;

temp = 0;
% while temp < 20
while true

    allAudioData = [];
    voiceMessages = [];

    fprintf("%s %i, \n", "Recording bulk: ", temp);

    audioData = audioInput();

    tic

    processedData = audioDataToSymbols(audioData);
    messages = reshape(processedData, frameSize, []);
    
    if l == 17
        l = 1;
    end

    bulk_header = bulk_headers(:, l);

    l = l + 1;

    fprintf("%s %i \n", "Finished recording bulk:", l-2);
    
    % Transmitting the signal
    bitStream = [];
    k = 1; j = 1;

    % messages = voiceMessages;

    for i = 1:size(messages, 2)
        if k == (size(messages, 2) + 1)
            k = 1;
        end
        if j == 33
            j = 1;
        end

        message = messages(:, k);
        header = headers(:, j);

        k = k + 1; j = j + 1;

        bitStream = [bitStream; preamble; bulk_header; header; message];

        if i == 1
            bitStream = [bitStream; preamble; bulk_header; header; message];
        end

        allHeadersSent = [allHeadersSent; ...
            [16*mode(header(1:3)) + 4*mode(header(4:6)) + mode(header(7:9)), ...
             4*mode(bulk_header(1:3)) + mode(bulk_header(4:6))]];
    end

    % bitStream = [bitStream; preamble; bulk_header; header; zeros(frameSize, 1)];
    
    bitStream = [bitStream; preamble; bulk_header; header; message];

    bitStream = [junk; bitStream; junk];

    % Modulating and transmitting the bit-stream
    bitStreamMod = pskmod(bitStream, M, pi/M, "gray");

    txSignal = upfirdn(bitStreamMod, rrcFilter, sps, 1);

    fprintf("%s %i \n", "Transmitting the signal from bulk: ", l-2);

    % transmitRepeat(tx, txSignal);
    tx(txSignal);

    temp = temp + 1;

    toc
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