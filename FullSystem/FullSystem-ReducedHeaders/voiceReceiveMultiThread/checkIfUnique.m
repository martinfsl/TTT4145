function isUnique = checkIfUnique(...
    allHeaders, h, bwView, possibleHeaders)
    
    if ~isempty(allHeaders)
        allHeaders = allHeaders(:, 1);
    end

    isUnique = 0;

    if length(allHeaders) > bwView
        allHeadersCheck = allHeaders(end-bwView:end);
    elseif length(allHeaders) <= bwView
        allHeadersCheck = allHeaders;
    end

    if (~ismember(h, allHeadersCheck) && ...
         ismember(h, possibleHeaders))

        % if h_bulk == prev_bulk || h_bulk == (prev_bulk + 1) || (h_bulk == 0 && prev_bulk == 15)
        %     isUnique = 1;
        % end
        isUnique = 1;
    end

end