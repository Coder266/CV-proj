%Trajetórias
%Criar imagem com os retângulos
% Struct objeto:
%     ID;
%     Lista de posições;
%     
% Para cada frame:
%     Ver os objetos na frame;
%     Comparar o IOU com os objetos existentes;
%     Se der match, adicionar à struct do objeto;

import ObjectRegion.*;

clear; close all;
set(gcf,'position',[100,20,900,900]);

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

contrastTh = 0.25;
minArea = 500;

objList = [];
objCount = 0;

for frame=1:nimgs
    fullnum = compose("%04d", frame-1);
    img = imread(src_path + "\frame_"+fullnum+".jpg");

    imgBW = rgb2gray(img);
    
    D = (double(imgBW) - double(background))./double(background);

    imgContrast = zeros(sizex, sizey);
    imgContrast(D>contrastTh) = 255;
    imgContrast(D<-contrastTh) = 255;

    figure(1);
    imgShapes = medfilt2(imgContrast,[8 8]);

    [lb, num] = bwlabel(imgShapes);
    regionProps = regionprops(lb,'area','FilledImage','Centroid');
    inds = find([regionProps.Area] > minArea);
    
%     subplot(2,2,1);
    imshow(img);
    regnum = length(inds);
    frameObjs.objs = [];
    if regnum
        for j=1:regnum
            [lin, col]= find(lb == inds(j));
            upLPoint = min([lin col]);
            dWindow  = max([lin col]) - upLPoint + 1;
           
%             subplot(2,2,1);
            rectangle('Position',[fliplr(upLPoint) fliplr(dWindow)],'EdgeColor',[1 1 0],...
                'linewidth',2);
   
            obj = ObjectRegion(0, regionProps(inds(j)).Centroid,fliplr(dWindow));
            if frame > 1
                [M,I] = max(obj.findMatches(objList(frame-1).objs));
                if M > 0.15
                    obj = obj.setId(objList(frame-1).objs(I).id);
                else
                    objCount = objCount+1;
                    obj = obj.setId(objCount);
                end
            else
                objCount = objCount+1;
                obj = obj.setId(objCount);
            end
            
            frameObjs.objs = [frameObjs.objs obj];

            text(upLPoint(2), upLPoint(1), int2str(obj.id),'Color','blue','FontSize',14);
        end
        objList = [objList frameObjs];
    end
    
%     subplot(2,2,2); imshow(imgBW);
%     subplot(2,2,3); imshow(imgContrast);
%     subplot(2,2,4); imshow(imgShapes);

    %Tratamento de Objetos
    
    


%     pause
end
