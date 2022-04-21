classdef Element < handle
    properties
        id
        posList
        frameList
    end

    methods
        function obj = Element(id, pos, frame)
            obj.posList{1} = pos;
            obj.frameList = frame;
            obj.id = id;
        end

        function obj = addPos(obj, pos, frame)
            obj.posList{end+1} = pos;
            obj.frameList = [obj.frameList frame];
        end

        function predicted_pos = getPredictedPos(obj, frame)
            if length(obj.posList) == 1
                predicted_pos = obj.posList{end};
            else
                range = min(length(obj.posList), 5);
                vel = (obj.posList{end}(1:2) - obj.posList{end-range+1}(1:2)) / (obj.frameList(end) - obj.frameList(end-range+1));
                predicted_xy = obj.posList{end}(1:2) + vel * (frame - obj.frameList(end));
                predicted_pos = [predicted_xy obj.posList{end}(3:4)];
            end
        end
    end
end