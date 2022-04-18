classdef Heatmap
    %HEATMAP Class containing and manipulating the image heatmap
    %   Detailed explanation goes here
    
    properties
        matrix
        g = 100
    end
    
    methods
        function obj = Heatmap(width,height)
            %HEATMAP Construct an instance of this class
            %   Detailed explanation goes here
            obj.matrix = zeros(width, height);
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        
        function obj = addOccurrence(obj, x,y)
            %ADDOCURRENCE Adds an occurrence to the heatmap
            %   Detailed explanation goes here
            [szx szy] = size(obj.matrix);
            h = fspecial('gaussian', [2*obj.g+1 2*obj.g+1], 20);
            
            if x<obj.g
                h = h(obj.g-x:2*obj.g+1, 1:2*obj.g+1);
            end
            
            if y<obj.g
                h = h(obj.g-x:2*obj.g+1, 1:2*obj.g+1);
            end
            
            
            
            obj.matrix(x-obj.g:x+obj.g, y-obj.g:y+obj.g) = obj.matrix(x-obj.g:x+obj.g, y-obj.g:y+obj.g) + h;
        end
        
        function plotHeatmap(obj)
            %PLOTHEATMAP Plots the contained heatmap
            scaled = rescale(obj.matrix, 0, 1);
            GrayIndex = uint8(floor(scaled * 255));
            map = jet(255);
            rgb = ind2rgb(GrayIndex, map);
            figure, imshow(rgb);
        end
    end
end

