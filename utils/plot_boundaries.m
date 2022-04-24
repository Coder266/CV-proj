function img = plot_boundaries(img, struct, frame)
    objects = struct.dataset.frame{1, frame}.objectlist.object;
    nobjects = length(objects);
    
    for i=1:nobjects
        h = str2double(objects{1, i}.box.Attributes.h);
        w = str2double(objects{1, i}.box.Attributes.w);
        xc = str2double(objects{1, i}.box.Attributes.xc);
        yc = str2double(objects{1, i}.box.Attributes.yc);
        img = insertShape(img, 'Rectangle', [xc-w/2, yc-h/2, w, h], 'Color', 'red','Opacity',0.7,'LineWidth',3);
    end
end