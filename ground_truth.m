clear; close all;

img_folder_path = "C:\Users\david\Documents\MATLAB\PROJ\View_001";
ground_truth_path = "C:\Users\david\Documents\MATLAB\PROJ\PETS2009-S2L1.xml";

imgDs = imageDatastore(img_folder_path);
ground_truth_object = readstruct(ground_truth_path);
% xml2struct

nimgs = length(imgDs.Files);
for i=1:nimgs
   figure(1);
   hold on;
   imshow(imgDs.readimage(i));
   plot_boundaries(ground_truth_object, i); 
   pause;
end

function plot_boundaries(struct, frame)
    objects = struct.frame(frame).objectlist.object;
    nobjects = length(objects);
    
    for i=1:nobjects
        h = objects(i).box.hAttribute;
        w = objects(i).box.wAttribute;
        xc = objects(i).box.xcAttribute;
        yc = objects(i).box.ycAttribute;
        rectangle("Position",[xc-w/2, yc-h/2, w, h])
    end
end