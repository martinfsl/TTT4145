function isUnique = checkIfUnique(...
    allHeaders, h, bwView, possibleHeaders)
    

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