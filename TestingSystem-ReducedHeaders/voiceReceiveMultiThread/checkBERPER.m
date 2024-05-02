num_packetsLost = sum(str2double(info(:, 6)));
PER = num_packetsLost/800;

BER = sum(str2double(info(:, 8)))/(800*2000*2);

fprintf("%s %i %s %i \n", "BER (%): ", BER*100, " PER (%): ", PER*100);