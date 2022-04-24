classdef ObjectInterface < handle
    properties
        posList
        lastFrame
        frameList
    end
    methods (Abstract)
        drawRectangle
        getId
    end

    methods
        function obj = ObjectInterface(pos, frame)
            obj.posList{1} = pos;
            obj.lastFrame = frame;
            obj.frameList = frame;
        end

        function obj = addPos(obj, pos, frame)
            obj.posList{end+1} = pos;
            obj.lastFrame = frame;
            obj.frameList = [obj.frameList frame];
        end

        function pos = getPos(obj)
            pos = obj.posList{end};
        end
        
        %This function returns the expected difference, in pixels, between
        %the same object in two different frames
        function diff = matchDiff(obj, pos)
            % TODO: consider difference of frames when calculating the
            % expected position
            if length(obj.posList) == 1
                diff = sqrt(sum((obj.posList{end}(1:2) - pos(1:2)).^2));
            else
                range = min(length(obj.posList), 2); %treshold to which consider previous movement
                
                vel = (obj.posList{end}(1:2) - obj.posList{end-range+1}(1:2)) / range;
                expectedPos = obj.posList{end}(1:2) + vel * ( obj.frameList(end) - obj.frameList(end-1));
                
                diff = sqrt(sum((expectedPos - pos(1:2)).^2));
            end
        end
    end
end

