classdef ObjectInterface < handle
    properties
        posList
        lastFrame
    end
    methods (Abstract)
        drawRectangle
        getId
    end

    methods
        function obj = ObjectInterface(pos, frame)
            obj.posList{1} = pos;
            obj.lastFrame = frame;
        end

        function obj = addPos(obj, pos, frame)
            obj.posList{end+1} = pos;
            obj.lastFrame = frame;
        end

        function pos = getPos(obj)
            pos = obj.posList{end};
        end
        
        function diff = matchDiff(obj, pos, frame)
            % TODO use size, not only pos
            if length(obj.posList) == 1
                diff = sqrt(sum((obj.posList{end}(1:2) - pos(1:2)).^2));
            else
                range = min(length(obj.posList), 3);
                vel = (obj.posList{end}(1:2) - obj.posList{end-range+1}(1:2)) / range;
                expectedPos = obj.posList{end}(1:2) + vel * (frame - obj.lastFrame);
                diff = sqrt(sum((expectedPos - pos(1:2)).^2));
            end
        end
    end
end

