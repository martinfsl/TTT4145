% dm = str2double(holder(4, 4:end));
% symerr(dm, trueMessages(:, 4)')
% 
% symerr(dm, trueMessages')

for i = 1:8
    dm = str2double(holder(i, 4:end));
    symerr(dm, trueMessages')
end