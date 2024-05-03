function isUnique = checkIfUnique(...
    allHeaders, h, bwView, possibleHeaders)
    
    if ~isempty(allHeaders)
        allHeaders = str2double(allHeaders(:, 1));
    end

    isUnique = 0;

    if length(allHeaders) > bwView
        allHeadersCheck = allHeaders(end-bwView:end);
    elseif length(allHeaders) <= bwView
        allHeadersCheck = allHeaders;
    end

    if (~ismember(h, allHeadersCheck) && ...
         ismember(h, possibleHeaders))

        isUnique = 1;
    end

end