% clear; clc; run setupReceiver.m;

run checkFoundMessages.m

s = struct;
s.allHeadersAcrossBulks = allHeadersAcrossBulks;
s.info = info;

save 'Run2_v2/run_10.mat' s;