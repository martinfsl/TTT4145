num_run = "Run2";

infoAll = [];

% % Old format - Run 1 and 2
% for i = 1:10
%     load(num_run + "/run_" + i + ".mat");
%     allHeadersAcrossBulks = s.allHeadersAcrossBulks;
%     run checkFoundMessages.m
%     infoAll = [infoAll; info];
% end

% New format
for i = 1:10
    load(num_run + "/run_" + i + ".mat");
    infoAll = [infoAll; s.info];
end