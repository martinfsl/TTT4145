function isUnique = checkIfUnique(...
    allHeaders, h, bwView, possibleHeaders, ...
    invalidBulkHeaders, h_bulk, bulk_bwView)
    

    isUnique = 0;

    if length(allHeaders) > bwView
        allHeadersCheck = allHeaders(end-bwView:end);
    elseif length(allHeaders) <= bwView
        allHeadersCheck = allHeaders;
    end

    if length(invalidBulkHeaders) > bulk_bwView
        invalidBulkHeadersCheck = invalidBulkHeaders(end-bulk_bwView:end);
    elseif length(invalidBulkHeaders) <= bulk_bwView
        invalidBulkHeadersCheck = invalidBulkHeaders;
    end

    if (~ismember(h, allHeadersCheck) && ...
         ismember(h, possibleHeaders) && ...
        ~ismember(h_bulk, invalidBulkHeadersCheck))

        isUnique = 1;
    end

end