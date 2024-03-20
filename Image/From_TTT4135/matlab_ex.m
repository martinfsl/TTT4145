% imagesc(lenag);
% colormap(gray(255));

cA = lenag;

for i = 1:3

    [cA, cH, cV, cD] = dwt2(cA,'db1','mode','per');
    
    figure(i);
    
    subplot(2, 2, 1);
    imagesc(cA);
    colormap(gray(255));
    title("LL");
   
    subplot(2, 2, 2);
    imagesc(cH);
    colormap(gray(255));
    title("HL");
    
    subplot(2, 2, 3);
    imagesc(cV);
    colormap(gray(255));
    title("LH");
    
    subplot(2, 2, 4);
    imagesc(cD);
    colormap(gray(255));
    title("HH");
    
    sgtitle("Using 'db1', iteration " + i);

end

