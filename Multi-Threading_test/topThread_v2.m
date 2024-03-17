% Initialize the buffer
global buffer;
buffer = [];

% Define the buffer size for processing
global bufferProcessSize;
bufferProcessSize = 5;

% Create a timer object for processing the buffer
bufferTimer = timer('ExecutionMode', 'fixedRate', ...
                    'Period', 0.1, ... % Adjust the period to suit your needs
                    'TimerFcn', @(~,~) processBuffer());

start(bufferTimer);

% Example of continuously receiving data and adding to the buffer
while true
    newData = rand(1); % Simulate receiving new data, replace with actual data reception
    buffer = [buffer, newData]; % Append new data to the buffer
    disp(buffer);
    pause(1); % Adjust based on the rate of incoming data
end
