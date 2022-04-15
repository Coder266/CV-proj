classdef Element < ObjectInterface
    properties
        id
    end

    methods
        function obj = Element(id, pos, frame)
            obj@ObjectInterface(pos, frame);
            obj.id = id;
        end

        function drawRectangle(obj)
            rectangle('Position', obj.posList{end},'EdgeColor',[1 1 0], 'linewidth',2);
            text(obj.posList{end}(1), obj.posList{end}(2), int2str(obj.id),'Color','blue','FontSize',14);
        end

        function id = getId(obj)
            id = obj.id;
        end
    end

end

