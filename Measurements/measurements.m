close all; clear; clc;

fileName = "Data\polarization_LOS-3.csv";
file = readmatrix(fileName); 

% hard coded numbers for formatting (same file format each time)
data = file(4:end,1:2);
xAxis = data(144:end,2); % frequency axis 
yAxis = data(144:end,1); % avg VRMS power [dBm]

% power calculations
attenuator = 30.15; % cable + attenuator loss in dB
indices = 398:411; % indices ~ 369:431 (signal), ~ 395:412 (carrier) % when using 801 points
receivedSignalPower = 10*log10(sum( 10.^(yAxis(indices)/10) ))

% transmit power
transmitSignalPower = receivedSignalPower + attenuator

% polarization loss
FSL = 55; % 7.5 m, 1.8 GHz
transmitPower = 4.5; % dBm (using measured data)
polarizationLoss = transmitPower - FSL - receivedSignalPower 

indicesPlot = 300:500;
stem(xAxis(indicesPlot), yAxis(indicesPlot)); hold on;
stem(xAxis(indices), yAxis(indices), 'r')

% noise calculations
k = 1.38e-23;
bandwidth = xAxis(end)-xAxis(1);

totalNoisePower_abs = sum( 10.^(yAxis(:)/10) );
% totalNoisePower = 10*log10(totalNoisePower_abs)
% antennaTemperature = totalNoisePower_abs/(k*bandwidth)
% antennaNoiseDensity = 10*log10((10^(yAxis(1)/10) + 10^(yAxis(end)/10))/(2*bandwidth))