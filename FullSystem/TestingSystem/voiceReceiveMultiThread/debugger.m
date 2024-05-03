tempHeaders = allHeadersAcrossBulks(121:128, :);

for i = 1:size(tempHeaders, 1)
    dm = str2double(tempHeaders(i, 4:end));
    dh = str2double(tempHeaders(i, 1));
    tm = trueMessages(:, dh+1)';
    disp(symerr(dm, tm));
end