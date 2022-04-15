function imgShapes = get_shapes_img(img, background, contrastTh, medianSize)
    [sizex, sizey, ~] = size(img);
    imgBW = rgb2gray(img);
    
    D = (double(imgBW) - double(background))./double(background);

    imgContrast = zeros(sizex, sizey);
    imgContrast(D>contrastTh) = 255;
    imgContrast(D<-contrastTh) = 255;

    imgShapes = medfilt2(imgContrast,[medianSize medianSize]);
end