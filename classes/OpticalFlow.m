classdef OpticalFlow
    %OPTICALFLOW Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       u
       v
       alpha
    end
    
    methods
        function obj = OpticalFlow(sizex, sizey)
            %OPTICALFLOW Construct an instance of this class
            %   Detailed explanation goes her
            obj.u = zeros(sizex, sizey);
            obj.v = zeros(sizex, sizey);
            obj.alpha = 10;
        end
        
        function obj = hornSchunck(obj, img1,img2)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            %compute image gradients (using sobel)
            [gradx,grady] = imgradientxy(rgb2gray(img1), 'sobel');
            
            %compute temporal gradients
            gradt = double(rgb2gray(img2) - rgb2gray(img1));
            
            %compute neighbor velocity averages
            avgKernel=[0 0.25 0; 0.25 0 0.25; 0 0.25 0];  
            obj.u = zeros(size(obj.u));
            obj.v = zeros(size(obj.v));
            
            for i=1:10
                uavg = conv2(obj.u, avgKernel, 'same');
                vavg = conv2(obj.v, avgKernel, 'same');
            
                %compute
                u = uavg - (gradx .* ((gradx.*uavg) + (grady.*vavg)+gradt))./(obj.alpha^2 + gradx.^2 + grady.^2);
                v = vavg - (grady .* ((gradx.*uavg) + (grady.*vavg)+gradt))./(obj.alpha^2 + gradx.^2 + grady.^2);
                obj.u = u;
                obj.v = v; 
            end
        end
    end
end


