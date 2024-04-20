close all; clear all;

load("lenag_SD.mat");

% imshow(lenag, []);

% 2D-FFT
FFT_Y = fft2(lenag);
n = max(FFT_Y, [], "all");
FFT_Y_db = 10*log10(abs(fftshift(FFT_Y/n)));

% imagesc(FFT_Y);
% imshow(FFT_Y_db, []);

% This transform does not provide any useful information

% 2D-DCT
DCT_Y = dct2(lenag);

% For normalizing
m = max(DCT_Y, [], "all");

DCT_Y_db = 10*log10(abs(DCT_Y)/m);

% imshow(DCT_Y_db, []);

% Choosing an 8x8 block and taking the 2D-DCT
i = 500; j = 500;
block = lenag(i:i+7, j:j+7);

DCT_block = dct2(block);
DCT_block_db = 10*log10(abs(DCT_block)/m);

imshow(DCT_block_db, []);

