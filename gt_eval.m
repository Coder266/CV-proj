function [overlap, confusion_matrix] = gt_eval(gt_objects, found_elements)
    %to do: run a cycle to compare each object to the one it has the most
    %overlaping with and then anonther cycle to redo. To the GT box, see the
    %closest Found box, for each frame.
    total_area = 0;
    match_area = 0;
    true_positives   = 0;    
    
    for i=1:length(gt_objects)
        maxlap = 0;
        h   = str2double(gt_objects{1,i}.box.Attributes.h);
        w   = str2double(gt_objects{1,i}.box.Attributes.w);
        xc  = str2double(gt_objects{1,i}.box.Attributes.xc);
        yc  = str2double(gt_objects{1,i}.box.Attributes.yc);
        gt_pos = [xc-w/2, yc-h/2, w, h];

        for j=1:length(found_elements)
            found_pos = found_elements{1, j}.posList{1,end};

            overlap = bboxOverlapRatio(gt_pos, found_pos);
            if overlap > maxlap
               maxlap = overlap;
               to_remove = j;
               match_area = match_area + min( (found_pos(3)*found_pos(4)) , (gt_pos(3)*gt_pos(4)) );
               total_area = total_area + (gt_pos(3)*gt_pos(4));
            end
            
        end
        if(maxlap > 0.1) %match found
            found_elements(to_remove) = [];
            true_positives = true_positives + 1;
        end
    end
        
    overlap = match_area / total_area;
    confusion_matrix = [true_positives length(found_elements) ; (length(gt_objects)-true_positives) 0 ];
end