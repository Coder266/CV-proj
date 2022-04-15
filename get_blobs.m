function blobs = get_blobs(imgShapes, minArea)
    [lb, ~] = bwlabel(imgShapes);
    regionProps = regionprops(lb,'area','FilledImage','Centroid');
    inds = find([regionProps.Area] > minArea);
    
    regnum = length(inds);

    blobs = [];

    if regnum
        for j=1:regnum
            [lin, col]= find(lb == inds(j));
            upLPoint = min([lin col]);
            dWindow  = max([lin col]) - upLPoint + 1;
   
            blob.pos = [fliplr(upLPoint), fliplr(dWindow)];
            
            blobs = [blobs blob];
        end
    end
end