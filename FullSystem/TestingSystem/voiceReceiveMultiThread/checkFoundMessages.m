amountOfFrames = 8;

% Set up true message
rng(1000);
trueMessages = randi([0 M-1], amountOfFrames*frameSize, 1);
trueMessages = reshape(trueMessages, frameSize, amountOfFrames);

trueMessages_bits = [];
for i = 1:size(trueMessages, 2)
    trueMessages_bits = [trueMessages_bits, ...
        reshape(de2bi(trueMessages(:, i)', 2, 'left-msb'), [], 1)];
end

headersInBulk = [];

packetsLost = 0;

info = [];
bulkInfo = [];

temp = [];
temp_packetsLost = 0;

prev_h_bulk = 0;
prev_h = -1;
for i = 1:size(allHeadersAcrossBulks, 1)
    curr_h = str2num(allHeadersAcrossBulks(i, 1));
    curr_h_bulk = str2num(allHeadersAcrossBulks(i, 2));
    curr_message = str2double(allHeadersAcrossBulks(i, 4:end));

    curr_message_bits = de2bi(curr_message, 2, 'left-msb');
    curr_message_bits = reshape(curr_message_bits, [], 1);

    % % Old way
    % corr_message = trueMessages(:, curr_h+1)';
    % corr_message_bits = de2bi(corr_message, 2, 'left-msb');
    % corr_message_bits = reshape(corr_message_bits, [], 1);

    if curr_h_bulk == prev_h_bulk + 1 || (curr_h_bulk == 0 && prev_h_bulk == 15)
        temp_packetsLost = temp_packetsLost + (amountOfFrames - size(temp, 1));
        bulkInfo = ["bulk", temp(1, 4), "num headers", size(temp, 1), ...
                    "packets lost", temp_packetsLost, ...
                    "error", sum(str2double(temp(:, 6)))];

        info = [info; bulkInfo];

        temp = [];
        temp_packetsLost = 0;

        bulkInfo = [];

        error = min(symerr(curr_message_bits, trueMessages_bits));

        % temp = [temp; ["header", curr_h, "bulk", curr_h_bulk, ...
        %        "error", symerr(curr_message_bits, corr_message_bits)]];

        temp = [temp; ["header", curr_h, "bulk", curr_h_bulk, ...
               "error", error]];

        prev_h_bulk = curr_h_bulk;
        prev_h = -1;
    elseif curr_h_bulk == prev_h_bulk
        if curr_h >= prev_h
            error = min(symerr(curr_message_bits, trueMessages_bits));

            % temp = [temp; ["header", curr_h, "bulk", curr_h_bulk, ...
            %                "error", symerr(curr_message_bits, corr_message_bits)]];

            temp = [temp; ["header", curr_h, "bulk", curr_h_bulk, ...
                   "error", error]];

            prev_h_bulk = curr_h_bulk;
            prev_h = curr_h;
        else
            temp_packetsLost = temp_packetsLost + 1;
        end
    else
        temp_packetsLost = temp_packetsLost + 1;
    end

end

temp_packetsLost = temp_packetsLost + (amountOfFrames - size(temp, 1));
bulkInfo = ["bulk", temp(1, 4), "num headers", size(temp, 1), ...
            "packets lost", temp_packetsLost, ...
            "error", sum(str2double(temp(:, 6)))];

info = [info; bulkInfo];
