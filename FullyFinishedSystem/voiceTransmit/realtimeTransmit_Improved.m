allHeadersSent = [];

% Setting up junk as filler
rng(9982);
junkSize = amountOfFrames*(length(preamble) + size(bulk_headers, 1) + ...
                           size(headers, 1) + frameSize);
junk = randi([0 M-1], junkSize/2, 1);

% audioInput = audioDeviceReader('SampleRate', 11200, 'NumChannels', 1, 'SamplesPerFrame', frameSize/4);

audioInput = audioDeviceReader('SampleRate', 11200, 'NumChannels', 1, ...
                               'SamplesPerFrame', amountOfFrames*frameSize/4);

symbolTime = 1.1e-5; % sps / sampleRate

% Works without packet loss when using 'fixedSpacing' on the timer
totalTime = 2;
playbackTime = 0.05;

playTimer = timer('ExecutionMode', 'fixedSpacing', ...
    'Period', playbackTime, ...
    'TimerFcn', ...
        @(~, ~)recordNextAudio(audioInput, frameSize));

global l
l = 1;

global voiceMessages
voiceMessages = [];

start(playTimer);

temp = 0;
% while temp < 20
while true

    if size(voiceMessages, 2) > amountOfFrames
    
        tic
        
        if l == 17
            l = 1;
        end
    
        bulk_header = bulk_headers(:, l);

        l = l + 1;
        
        % Transmitting the signal
        bitStream = [];
        k = 1; j = 1;
    
        messages = voiceMessages(:, 1:amountOfFrames);
        voiceMessages = voiceMessages(:, amountOfFrames+1:end);
    
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
    
            allHeadersSent = [allHeadersSent; ...
                [16*mode(header(1:3)) + 4*mode(header(4:6)) + mode(header(7:9)), ...
                 4*mode(bulk_header(1:3)) + mode(bulk_header(4:6))]];
        end
    
        bitStream = [bitStream; preamble; bulk_header; header; zeros(frameSize, 1)];
        
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
end
