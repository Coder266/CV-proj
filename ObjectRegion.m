classdef ObjectRegion
    %OBJECTREGION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id = 0;
        center = 0;
        dim = [0 0];
    end
    
    methods
        function obj = ObjectRegion(id,center, dim)
            %OBJECTREGION Construct an instance of this class
            %   Detailed explanation goes here
            obj.id = id;
            obj.center = center;
            obj.dim = dim;
        end
        
        function outputArg = overlap(new)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
        end
    end
end

