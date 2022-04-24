classdef Group < ObjectInterface
    properties
        elements
    end

    methods
        function group = Group(pos, frame, elements)
            group@ObjectInterface(pos, frame);
            group.elements = elements;
        end

        function group = addElement(group, ele)
            group.elements{end+1} = ele;
        end

        function [new_group, objs] = split(group, blobs, frame, matchingTh)
            new_group = group;
            objs = {};
            for i=1:size(blobs, 1)
                for j=1:length(new_group.elements)
                    if bboxOverlapRatio(blobs(i, :), new_group.elements{j}.getPredictedPos(frame)) > matchingTh
                        obj = new_group.elements{j};
                        obj = obj.addPos(blobs(i, :), frame);
                        objs{end+1} = obj;
                        new_group.elements(j) = [];
                        break;
                    end
                end
            end
        end

        function group = addPos(group, pos, frame)
            if ismember(frame, group.frameList)
                return
            end
            group.posList = [group.posList; pos];
            group.frameList = [group.frameList frame];

            for i=1:length(group.elements)
                el_pos = group.elements{i}.getPos();
                pos_diff = (group.posList(end, 1:2) - group.posList(end-1, 1:2)) / ...
                    (group.frameList(end) - group.frameList(end-1));
                adjusted_pos = el_pos(1:2) + pos_diff * (frame - group.elements{i}.getLastFrame());
                group.elements{i} = group.elements{i}.addPos([adjusted_pos el_pos(3:4)], frame);
            end
        end

        function ids = getId(group)
            ids = zeros(1, length(group.elements));
            for i=1:length(group.elements)
                ids(i) = group.elements{i}.getId();
            end
        end
        
        function objs = getElements(group)
            objs = group.elements;
        end

        function res = isEmpty(group)
            res = isempty(group.elements);
        end

        function imgOut = drawRectangleImg(group, imgIn)
            ids = group.getId();
            imgOut = insertShape(imgIn, 'Rectangle', group.posList(end, :));
            imgOut = insertText(imgOut, [group.posList(end, 1) group.posList(end, 2)], int2str(ids));
        end
    end
end