classdef Element < ObjectInterface
    properties
        id
    end

    methods
        function obj = Element(id, pos, frame)
            obj@ObjectInterface(pos,frame);
            obj.id = id;
        end

        function obj = addPos(obj, pos, frame)
            if ismember(frame, obj.frameList)
                return
            end
            obj.posList = [obj.posList; pos];
            obj.frameList = [obj.frameList frame];
        end
        
        function img = drawRectangleImg(obj, img, showBBox, showIds)
            if showBBox
                img = insertShape(img, 'Rectangle', obj.posList(end, :));
            end
            if showIds
                img = insertText(img, [obj.posList(end, 1) obj.posList(end, 2)], int2str(obj.id));
            end
        end

        function id = getId(obj)
            id = obj.id;
        end

        function els = getElements(obj)
            els = {obj};
        end
    end
end