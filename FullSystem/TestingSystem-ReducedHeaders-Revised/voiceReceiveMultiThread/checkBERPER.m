error = sum(str2double(infoAll(:, 8)));
numHeaders = sum(str2double(infoAll(:, 4)));
BER = error / (numHeaders*4000);

numPacketsTotal = 4000;
PER = 1-numHeaders/numPacketsTotal;

fprintf("%s %i %s %i\n", "BER:", BER, "PER:", PER);