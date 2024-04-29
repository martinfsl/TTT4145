num_run = "Run1_v2";

infoAll = [];

% New format
for i = 1:10
    load(num_run + "/run_" + i + ".mat");
    infoAll = [infoAll; s.info];
end