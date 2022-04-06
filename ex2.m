clear; close all;

src_path = "C:\Users\andre\OneDrive - Universidade de Lisboa\Documentos\MEIC\2a3p\CV\Project\Crowd_PETS09\S2\L1\Time_12-34\View_001";

% imgDs = imageDatastore(img_folder_path);
% imgDsGray = imgDs.transform(@(x) rgb2gray(x));
nimgs = length(dir(src_path + '/*.jpg'));
[sizex, sizey, ~] = size(imread(src_path + "\frame_0000.jpg"));

% background
subset_size = 30;
subset = [];
for frame=1:subset_size
    fullnum = compose("%04d", frame-1);
    img = imread(src_path + "\frame_"+fullnum+".jpg");
    
    imgBW = rgb2gray(img);
    subset = [subset imgBW];
end

subset = reshape(subset, sizex, sizey, 30);
background = median(subset, 3);

contrastTh = 0.15;
minArea = 500;

for frame=1:nimgs
    fullnum = compose("%04d", frame-1);
    img = imread(src_path + "\frame_"+fullnum+".jpg");

    imgBW = rgb2gray(img);

    imgContrast = zeros(sizex, sizey);
    for i=1:sizex
        for j=1:sizey
            contrast = (double(imgBW(i, j)) - double(background(i, j))) / double(background(i, j));
            if (contrast > contrastTh) || (contrast < -contrastTh)
                imgContrast(i, j) = 255;
            end
        end
    end
    figure(1);
    imgShapes = medfilt2(imgContrast,[8 8]);

    [lb, num] = bwlabel(imgShapes);
    regionProps = regionprops(lb,'area','FilledImage','Centroid');
    inds = find([regionProps.Area] > minArea);
    
    subplot(2,2,1); imshow(img);
    regnum = length(inds);
    if regnum
        for j=1:regnum
            [lin, col]= find(lb == inds(j));
            upLPoint = min([lin col]);
            dWindow  = max([lin col]) - upLPoint + 1;
           

            subplot(2,2,1);
            rectangle('Position',[fliplr(upLPoint) fliplr(dWindow)],'EdgeColor',[1 1 0],...
                'linewidth',2);
        end
    end

    subplot(2,2,2); imshow(imgBW);
    subplot(2,2,3); imshow(imgContrast);
    subplot(2,2,4); imshow(imgShapes);

%     pause
end