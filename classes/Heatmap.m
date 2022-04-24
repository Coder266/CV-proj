classdef Heatmap
    %HEATMAP Class containing and manipulating the image heatmap
    %   Detailed explanation goes here
    
    properties
        matrix
        sizex
        sizey
        g
        h
    end
    
    methods
        function obj = Heatmap(width,height, distance)
            %HEATMAP Construct an instance of this class
            %   Detailed explanation goes here
            obj.sizex = width;
            obj.sizey = height;
            obj.g = distance;
            obj.h = fspecial('gaussian', [2*obj.g+1 2*obj.g+1],obj.g/5);
            obj.matrix = zeros(width+2*obj.g, height+2*obj.g);
        end
        
        function obj = swapManhattan(obj)
            %ADDOCURRENCE Adds an occurrence to the heatmap
            %   Detailed explanation goes here                       
            obj.h = zeros(2*obj.g+1, 2*obj.g+1);
            for x = 1:2*obj.g+1
                for y = 1:2*obj.g+1
                    obj.h(x, y) = obj.g - (abs(x-obj.g-1) + abs(y-obj.g-1));
                end
            end
            obj.h(obj.h<0) = 0;
        end
        
        function obj = addOccurrence(obj, x,y)
            %ADDOCURRENCE Adds an occurrence to the heatmap
            %   Detailed explanation goes here                       
            obj.matrix(x:x+2*obj.g, y:y+2*obj.g) = obj.matrix(x:x+2*obj.g, y:y+2*obj.g) + obj.h;
        end
        
        function obj = addPos(obj, pos)
            %ADDOCURRENCE Adds a rectangle position to the heatmap
            %   Detailed explanation goes here     
            x = int16(pos(2)+pos(4)/2);
            y = int16(pos(1)+pos(3)/2);
            obj.matrix(x:x+2*obj.g, y:y+2*obj.g) = obj.matrix(x:x+2*obj.g, y:y+2*obj.g) + obj.h;
        end
        
        function map = getHeatmap(obj)
            mat = obj.matrix(obj.g+1:obj.g+obj.sizex, obj.g+1:obj.g+obj.sizey);
            scaled = rescale(mat, 0, 1);
            gray = uint8(floor(scaled * 255));
            map = jet(255);
            rgb = ind2rgb(gray, map);
            map = rgb;
        end
        
        function plotHeatmap(obj)
            %PLOTHEATMAP Plots the contained heatmap
            mat = obj.matrix(obj.g+1:obj.g+obj.sizex, obj.g+1:obj.g+obj.sizey);
            scaled = rescale(mat, 0, 1);
            gray = uint8(floor(scaled * 255));
            map = jet(255);
            rgb = ind2rgb(gray, map);
            figure, imshow(rgb);
        end

        function obj = divide(obj)
            obj.matrix = obj.matrix / 2;
        end
    end
end

