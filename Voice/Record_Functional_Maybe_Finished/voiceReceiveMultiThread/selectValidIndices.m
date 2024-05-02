function idx = selectValidIndices(idxIn, frameSize)
    idx = [];

    for i = 1:(length(idxIn)-1)
        if abs((idxIn(i) - idxIn(i+1))) > 200
            idx = [idx; idxIn(i)];
        end
    end
end