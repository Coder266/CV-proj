% imports
import get_background.*
import get_shapes_img.*
import get_blobs.*

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
contrastTh = 0.25;
minArea = 200;
medianSize = 12;
matchingTh = 0.15;


objList = [];
idCounter = 1;

for frame_idx=1:nimgs
    % get image
    fullnum = compose("%04d", frame_idx-1);
    img = imread(src_path + "\frame_"+fullnum+".jpg");

    % get shapes image using contrast
    imgShapes = get_shapes_img(img, background, contrastTh, medianSize);

    % get the current frame's blobs
    blobs = get_blobs(imgShapes, minArea);
    num_blobs = length(blobs);

    frame.objs = {};

    if frame_idx > 1
        % get last frame objs
        prev_objs = objList(frame_idx-1).objs;
        num_prev_objs = length(prev_objs);
        
        M = zeros(num_blobs, num_prev_objs);

        % get mathing matrix
        for blob_idx=1:num_blobs
            for prev_obj_idx=1:num_prev_objs
                 M(blob_idx, prev_obj_idx) = bboxOverlapRatio(blobs(blob_idx).pos, prev_objs{prev_obj_idx}.getPos()) > matchingTh;
            end
        end
        

        remaining_blob_idx = 1:num_blobs;

        % matching
        for blob_idx=1:num_blobs
            if ~any(remaining_blob_idx == blob_idx)
                continue;
            end

            done = false;
            matches = M(blob_idx, :);
            num_matches = sum(matches);

            % ids of prev objs that match
            idx_matches = find(matches);

            % if no match -> new obj
            if num_matches == 0
                % TODO get lost objects to try and match to this
                obj = Element(idCounter, blobs(blob_idx).pos, frame_idx);
                idCounter = idCounter + 1;
                frame.objs{end+1} = obj;
                remaining_blob_idx(remaining_blob_idx == blob_idx) = [];
            
            % many (prev) to 1 (current) -> group
            elseif num_matches > 1
                % create group and add all to group
                group = Group(prev_objs(idx_matches), blobs(blob_idx).pos, frame_idx);
                group = group.addPos(blobs(blob_idx).pos, frame_idx);

                % add group to list
                frame.objs{end+1} = group;
                remaining_blob_idx(remaining_blob_idx == blob_idx) = [];
            else
                % for every prev obj match see if there are more current matching
                for i=1:num_matches
                    current_matches = M(:, idx_matches(i));
    
                    % if 1 (prev) to many (current) -> split
                    if sum(current_matches) > 1
                        blobs_to_match_idx = intersect(find(current_matches), remaining_blob_idx);
                        objs = {};
                        if isa(prev_objs{idx_matches(i)}, 'Group')
                            % split group and get split objs
                            [group, objs] = prev_objs{idx_matches(i)}.split(blobs(blobs_to_match_idx), frame_idx);
                            prev_objs{idx_matches(i)} = group;
                            for j=1:length(objs)
                                objs{j} = objs{j}.addPos(blobs(blobs_to_match_idx(j)).pos, frame_idx);
                            end
                            % if the group is not empty add it to objs
                            if ~group.isEmpty()
                                frame.objs{end+1} = group;
                                % TODO add pos to group
                            end
                        else
                            % create new objs for each obj (TODO get old objs
                            % to match)
                            for j=1:length(blobs_to_match_idx)
                                obj = Element(idCounter, blobs(blobs_to_match_idx(j)).pos, frame_idx);
                                idCounter = idCounter + 1;
                                objs{end+1} = obj;
                            end
                        end
                        % add objs to objList and remove matched blobs
                        frame.objs = cat(2, frame.objs, objs);
                        remaining_blob_idx = setdiff(remaining_blob_idx, blobs_to_match_idx);
                        done = true;
                        break;
                    end
                end
                if done
                    continue;
                end
                
                % if 1 to 1
                % copy obj from last frame and add current pos
                obj = prev_objs{idx_matches};
                obj = obj.addPos(blobs(blob_idx).pos, frame_idx);
                frame.objs{end+1} = obj;
                remaining_blob_idx(remaining_blob_idx == blob_idx) = [];
            end
        end

        
    else
        % first frame, create an object per blob
        for blob_idx=1:num_blobs
            obj = Element(idCounter, blobs(blob_idx).pos, frame_idx);
            idCounter = idCounter + 1;
            frame.objs{end+1} = obj;
        end
    end

    objList = [objList frame];

    % show img with rectangles
    imshow(img);
    for i=1:length(frame.objs)
        frame.objs{i}.drawRectangle();
    end
    pause(0.0001)
    %pause
end
