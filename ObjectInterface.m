classdef ObjectInterface < handle
    properties
        posList
        frameList
    end

    methods(Abstract)
        getId
        addPos
        getElements
    end

    methods
        function obj = ObjectInterface(pos, frame)
            obj.posList = pos;
            obj.frameList = frame;
        end

        function predicted_pos = getPredictedPos(obj, frame)
            if size(obj.posList, 1) == 1
                predicted_pos = obj.posList(end, :);
            else
                idx = find(obj.frameList > frame - 10);
                if length(idx) < 2
                    idx = [length(obj.frameList)-1 length(obj.frameList)];
                end

                v = zeros(length(idx)-1, 2);
                for i = 1:length(idx)-1
                    v(i, :) = (obj.posList(idx(i+1), 1:2) - obj.posList(idx(i), 1:2)) / (obj.frameList(idx(i+1)) - obj.frameList(idx(i))) ;
                end
                predicted_xy = obj.posList(end, 1:2) + median(v) * (frame - obj.frameList(end));
                predicted_pos = [predicted_xy obj.posList(end , 3:4)];
            end
        end

        function pos = getPos(obj)
            pos = obj.posList(end, :);
        end

        function lastFrame = getLastFrame(obj)
            lastFrame = obj.frameList(end);
        end
    end
end