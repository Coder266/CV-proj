classdef ObjectRegion
    %OBJECTREGION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id = 0;
        center = 0;
        dim = [0 0];
    end
    
    methods
        function obj = ObjectRegion(id, center, dim)
            %OBJECTREGION Construct an instance of this class
            %   Detailed explanation goes here
            obj.id = id;
            obj.center = center;
            obj.dim = dim;
        end

        function obj = setId(obj, id)
            %OBJECTREGION Construct an instance of this class
            %   Detailed explanation goes here
            obj.id = id;
        end
        
        function iou = overlap(obj, new)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            iou = bboxOverlapRatio([obj.center obj.dim], [new.center new.dim]);
        end

        function matches = findMatches(obj, frameObjs)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            matches = zeros(1, length(frameObjs));
            for i=1:length(frameObjs)
                matches(i) = obj.overlap(frameObjs(i));
            end
        end
    end
end

