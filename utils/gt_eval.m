function [metrics] = gt_eval(gt_objects, found_objects, sizex, sizey, th)

    eval_matrix = zeros(length(found_objects),length(gt_objects));
    gt_matrix    = zeros(sizex,sizey);
    found_matrix = zeros(sizex,sizey);
    
    for i=1:length(gt_objects)
        maxlap = 0;
        
        h   = str2double(gt_objects{1,i}.box.Attributes.h);
        w   = str2double(gt_objects{1,i}.box.Attributes.w);
        xc  = str2double(gt_objects{1,i}.box.Attributes.xc);
        yc  = str2double(gt_objects{1,i}.box.Attributes.yc);
        gt_pos = [xc-w/2, yc-h/2, w, h];
        gt_matrix = drawNfill(gt_pos,gt_matrix);
        
        for j=1:length(found_objects)
            %Check if number of elements within
%             numberOfElements = getCount(found_objects{1,j}, 0); %number of objects within possible group (merge detections)
            found_pos = found_objects{1, j}.posList(end,:);     %position of object
            found_matrix = drawNfill(found_pos,found_matrix);
            overlap =  bboxOverlapRatio(gt_pos, found_pos);
            if overlap > maxlap
               maxlap = overlap;
               max_i  = i;
               max_j  = j;
%                to_remove = j;
               %match_area = match_area + min( (found_pos(3)*found_pos(4)) , (gt_pos(3)*gt_pos(4)) );
               %total_area = total_area + (gt_pos(3)*gt_pos(4));
            end
            
        end
        if(maxlap > th) %match found
            eval_matrix( max_j , max_i ) = 1;
        end
    end
    %Metrics
    merge = 0;
    for k=1:size(eval_matrix,1)
        if sum(eval_matrix(k, :)) > 1
            merge = merge + sum(eval_matrix(k, :));
        end
    end
    true_positives =  sum(eval_matrix, 'all') - merge;
    false_alarms = (size(eval_matrix,1) - nnz( ~all(eval_matrix == 0, 2)));
    det_failure = (size(eval_matrix,2) - nnz( ~all(eval_matrix == 0, 1)));
    match_area = sum(and(found_matrix,gt_matrix), 'all') / sum(or(found_matrix,gt_matrix), 'all');
    metrics = [true_positives merge false_alarms det_failure match_area];
end

function count = getCount(object,count)
    if isa(object,'Group')
        elements = object.elements;
        for e=1:elements
            count = count + getCount(elements{1,e}, numberOfElements);
        end
    else %isElement
        count = count + 1;
    end
end

function image = drawNfill(rect, image)
    xinit = round( rect(1) );
    xend  = round(xinit + (rect(3)/2) );
    yinit = round( rect(2) );
    yend  = round(yinit + (rect(4)/2) );
    for i=xinit:xend
       for j=yinit:yend
           image(j,i) = 1;
       end
    end   
end