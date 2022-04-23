classdef Frame
    properties
        id
        objs
    end
    
    methods
        function frame = Frame(id)
            frame.id = id;
            frame.objs = {};
        end

        function frame = addObject(frame, obj)
            frame.objs{end+1} = obj;
        end

        function objs = getObjs(frame)
            objs = frame.objs;
        end
    end
end