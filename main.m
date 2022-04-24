% imports
addpath utils
addpath classes

% setup
clear; close all;
set(gcf,'position',[100,20,900,900]);
figure(1);
hold on;

% img info
src_path = "..\View_001";
nimgs = length(dir(src_path + '/*.jpg'));
[sizex, sizey, ~] = size(imread(src_path + "\frame_0000.jpg"));

% background
subset_size = 30;
background = get_background(src_path, subset_size);

% params
ex = 3;
contrastTh = 0.25;
minArea = 350;
medianSize = 12;
matchingTh = 0.15;
edgeDistanceTh = 50;
heatmapSize = 100;
debug = false;

heatmap = Heatmap(sizex, sizey, heatmapSize);

if ex == 3
    markers = {};
end

objList = Frame.empty(1, 0);
hiding = {};
idCounter = 1;

for frame_idx=1:nimgs
    % get image
    fullnum = compose("%04d", frame_idx-1);
    img = imread(src_path + "\frame_"+fullnum+".jpg");

    % get shapes image using contrast
    imgShapes = get_shapes_img(img, background, contrastTh, medianSize);

    % get the current frame's blobs
    blobs = get_blobs(imgShapes, minArea);
    num_blobs = size(blobs, 1);
    
    frame = Frame(frame_idx);

    if debug
        disp(['frame ' int2str(frame_idx)]);
    end

    if frame_idx == 1
        for blob_idx=1:num_blobs
            obj = Element(idCounter, blobs(blob_idx, :), frame_idx);
            idCounter = idCounter + 1;
            frame = frame.addObject(obj);
        end
    else
        prev_objs = objList(frame_idx-1).getObjs();
        num_prev_objs = length(prev_objs);

        M = find_matches(blobs, prev_objs, frame_idx, matchingTh);
        S = cell(num_blobs, 1);
        S_alt = cell(num_prev_objs, 1);

        for i=1:num_blobs
            S{i} = find(M(i,:));
        end

        for i=1:num_prev_objs
            S_alt{i} = find(M(:,i))';
        end
        
        if debug
            disp(S)
            disp(S_alt)
        end

        for i=1:num_blobs
            for j=1:i-1
                if length(S{i}) == 1 && length(S{j}) == 1 ...
                        && S{i} == S{j}
                    for k=1:num_prev_objs
                        if S{i} == k && isequal(unique(S_alt{k}), unique([i j]))
                            % split
                            if debug
                                disp([int2str([i j k]) ' split'])
                            end
                            
                            if isa(prev_objs{k}, 'Group')
                                % split group and get split objs
                                [group, objs] = prev_objs{k}.split(blobs([i j], :), frame_idx, matchingTh);

                                if ~group.isEmpty()
                                    frame = frame.addObject(group);
                                end
                                for l=1:length(objs)
                                    frame = frame.addObject(objs{l});
                                end
                            else
                                % TODO move to function
                                obj1 = Element(idCounter, blobs(i, :), frame_idx);
                                idCounter = idCounter + 1;
                                frame = frame.addObject(obj1);

                                obj2 = Element(idCounter, blobs(j, :), frame_idx);
                                idCounter = idCounter + 1;
                                frame = frame.addObject(obj2);
                            end
                        end
                    end
                end
            end

            for j=1:num_prev_objs
                for k=1:j-1
                    if isequal(unique(S{i}), unique([j k])) ...
                            && length(S_alt{j}) == 1 && length(S_alt{k}) == 1 ...
                            && S_alt{j} == S_alt{k} && S_alt{k} == i
                        % merge
                        if debug
                            disp([int2str([i j k]) ' merge'])
                        end
                        group = Group(blobs(i, :), frame_idx, ...
                            cat(2, prev_objs{j}.getElements(), ...
                            prev_objs{k}.getElements()));
                        frame = frame.addObject(group);
                    end
                end

                if length(S{i}) == 1 && length(S_alt{j}) == 1 ...
                        && S{i} == j && S_alt{j} == i
                    % correspondence
                    if debug
                        disp([int2str([i j]) ' correspondence'])
                    end
                    obj = prev_objs{j};
                    obj = obj.addPos(blobs(i, :), frame_idx);
                    frame = frame.addObject(obj);
                end
            end

            if isempty(S{i})
                % new
                if debug
                    disp([int2str(i) ' new'])
                end

                if near_edge(blobs(i, 1:2), sizex, sizey, edgeDistanceTh)
                   % create new
                    obj = Element(idCounter, blobs(i, :), frame_idx);
                    idCounter = idCounter + 1;
                    frame = frame.addObject(obj);
                else
                    % check if is inside other blobs
                    done = false;
                    for j=1:num_blobs
                        if i ~= j && bboxOverlapRatio(blobs(i,:), blobs(j,:), 'Min') > 0.9
                            done = true;
                            break;
                        end
                    end
                    if done
                        if debug
                            disp('found inside another blob, deleting...')
                        end
                        continue;
                    end

                    % search hiding
                    for j=1:length(hiding)
                        if bboxOverlapRatio(blobs(i, :), hiding{j}.getPredictedPos(frame_idx)) > matchingTh
                            obj = hiding{j};
                            obj = obj.addPos(blobs(i, :), frame_idx);
                            frame = frame.addObject(obj);

                            done = true;
                            break;
                        end
                    end
                    if done
                        if debug
                            disp('found hiding object match')
                        end
                        continue;
                    end

                    % search groups
%                     for j=1:num_prev_objs
%                         if isa(prev_objs{j}, 'Group')
%                             [hasMatch, obj] = prev_objs{j}.checkMatch(blobs(i, :), matchingTh);
%                             if hasMatch
%                                 obj = obj.addPosition(blobs(i, :));
%                                 frame = frame.addObject(obj);
% 
%                                 done=true;
%                                 break;
%                             end
%                         end
%                     end
%                     if done
%                         continue;
%                     end

                    % else create new
                    obj = Element(idCounter, blobs(i, :), frame_idx);
                    idCounter = idCounter + 1;
                    frame = frame.addObject(obj);
                end
            end
        end

        for i=1:num_prev_objs
            if isempty(S_alt{i})
                % leaves
                if debug
                    disp([int2str(i) ' leaves'])
                end

                if ~near_edge(prev_objs{i}.getPos(), sizex, sizey, edgeDistanceTh)
                    hiding{end+1} = prev_objs{i};
                end
            end
        end
    end

    objList(frame_idx) = frame;
    
    % show img with rectangles
    if ex == 3
        marker_pos = zeros(2, frame.getNumObjs());
    end

    for i=1:frame.getNumObjs()
        img = frame.getObj(i).drawRectangleImg(img, ex);
        heatmap = heatmap.addPos(frame.getObj(i).getPos());
        if ex == 3
            obj_pos = frame.getObj(i).getPos();
            pos = [obj_pos(1) + obj_pos(3) / 2, obj_pos(2) + obj_pos(4) / 2];
            marker_pos(:, i) = pos;
        end
    end

    markers{frame_idx} = marker_pos;
    
    for i=frame_idx:-1:max(frame_idx - 6, 1)
        for j=1:size(markers{i}, 2)
            img = insertMarker(img, markers{i}(:, j)');
        end
    end
    

    imshow(img);
%     subplot(2,1,1), imshow(img);
%     subplot(2,1,2), imshow(heatmap.getHeatmap());

    pause();
end