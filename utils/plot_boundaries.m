function img = plot_boundaries(img, struct, frame)
    objects = struct.frame(frame).objectlist.object;
    nobjects = length(objects);
    
    for i=1:nobjects
        h = objects(i).box.hAttribute;
        w = objects(i).box.wAttribute;
        xc = objects(i).box.xcAttribute;
        yc = objects(i).box.ycAttribute;
        img = insertShape(img, 'Rectangle', [xc-w/2, yc-h/2, w, h], 'Color', 'red','Opacity',0.7,'LineWidth',3);
    end
end