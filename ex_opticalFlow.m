% setup
clear; close all;
% set(gcf,'position',[100,20,900,900]);
% figure(1);
% hold on;

% img info
src_path = "..\View_001";
nimgs = length(dir(src_path + '/*.jpg'));
[sizex, sizey, ~] = size(imread(src_path + "\frame_0000.jpg"));

opticFlow = opticalFlowHS;

h = figure;
movegui(h);
hViewPanel = uipanel(h,'Position',[0 0 1 1],'Title','Plot of Optical Flow Vectors');
hPlot = axes(hViewPanel);

for frame_idx=1:nimgs
    % get image
    fullnum = compose("%04d", frame_idx-1);
    img = imread(src_path + "\frame_"+fullnum+".jpg");
    imgBW = im2gray(img);  
    flow = estimateFlow(opticFlow, imgBW);
    imshow(img)
    hold on
    plot(flow,'DecimationFactor',[5 5],'ScaleFactor',60,'Parent',hPlot);
    hold off
    pause(10^-3)
end