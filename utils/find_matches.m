function matches = find_matches(blobs, objs, frame, matchingTh)
    % matrix with rows as blobs and collumns as prev objs
    matches = zeros(size(blobs, 1), length(objs));
    for i=1:size(blobs, 1)
        for j=1:length(objs)
            matches(i, j) = bboxOverlapRatio(blobs(i,:), objs{j}.getPredictedPos(frame)) > matchingTh;
        end
    end
end