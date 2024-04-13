function bitStream = modulateVoice(...
    data, headers, fillerSize, preamble, k, M)
    
    header = headers(:, k);

    rng(5520); filler1 = randi([0 M-1], fillerSize*2, 1);
    rng(6020); filler2 = randi([0 M-1], fillerSize*2, 1);

    bitStream = [filler1; preamble; header; data; filler2];
end