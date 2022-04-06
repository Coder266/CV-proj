clear; close all;

img_folder_path = "C:\Users\andre\OneDrive - Universidade de Lisboa\Documentos\MEIC\2a3p\CV\Project\Crowd_PETS09\S2\L1\Time_12-34\View_001";

imgDs = imageDatastore(img_folder_path);
imgDsGray = imgDs.transform(@(x) rgb2gray(x));
nimgs = length(imgDs.Files);
[sizex, sizey, ~] = size(imgDs.readimage(1));


% calculates background by using the median of *subset_size* images
subset_size = 30;

subset = permute(reshape(imgDsGray.subset(1:subset_size).readall, sizex, subset_size, sizey), [1 3 2]);

background = median(subset, 3);

% imshow(background);


% another way to calculate background (not working)
% for i=1:nimgs
%     img = imgDsGray.readimage(i)
%    background = sum([alpha * rgb2gray(imgDs.readimage(i)), (1-alpha) * background], "all");
% end

imgDsGray.reset
contrastTh = 0.15;

for frame=1:nimgs
    imgBW = imgDsGray.read;
%     imgcontrast = zeros(sizex, sizey);
    imgcontrastTh = zeros(sizex, sizey);
    for i=1:sizex
        for j=1:sizey
            contrast = (double(imgBW(i, j)) - double(background(i, j))) / double(background(i, j));
%             imgcontrast(i, j) = contrast;
            if (contrast > contrastTh) || (contrast < -contrastTh)
                imgcontrastTh(i, j) = 255;
            end
        end
    end
    figure(1);
%     subplot(2,2,1); imshow(background);
%     subplot(2,2,2); imshow(imgBW);
%     subplot(2,2,3); imshow(imgcontrast);
%     subplot(2,2,4); imshow(medfilt2(imgcontrastTh,[5 5]));
    imshow(medfilt2(imgcontrastTh,[5 5]));
    pause
end