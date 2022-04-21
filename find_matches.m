function matches = find_matches(blob, objs, frame, matchingTh)
    matches = zeros(1, length(objs));
    for i=1:length(objs)
        matches(i) = bboxOverlapRatio(blob.pos, objs(i).getPredictedPos(frame)) > matchingTh;
    end
end