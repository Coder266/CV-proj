function background = get_background(src_path, subset_size)
    [sizex, sizey, ~] = size(imread(src_path + "\frame_0000.jpg"));
    subset = [];
    for frame=1:subset_size
        fullnum = compose("%04d", frame-1);
        img = imread(src_path + "\frame_"+fullnum+".jpg");
        
        imgBW = rgb2gray(img);
        subset = [subset imgBW];
    end
    
    subset = reshape(subset, sizex, sizey, subset_size);
    background = median(subset, 3);
end