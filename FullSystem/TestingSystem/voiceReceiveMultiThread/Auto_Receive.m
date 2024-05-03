% clear; clc; run setupReceiver.m;

run checkFoundMessages.m

s = struct;
s.allHeadersAcrossBulks = allHeadersAcrossBulks;
s.info = info;

save 'Run2/run_11.mat' s;