classdef Group < ObjectInterface
    properties
        elements = {}
    end
    methods
        function group = Group(elements, pos, frame)
            group@ObjectInterface(pos, frame);
            if ~isa(elements, 'cell')
                error("Group elements are not a cell array")
            end
            group.elements = cat(2, group.elements, elements);
        end

        function group = addElements(group, elements)
            group.elements = cat(2, group.elements, elements);
        end

        function [group, objs] = split(group, blobs, frame)
            % find which elements matches the blobs and remove them
            % TODO break groups down into elements (recursive split)
            objs = {};
            
            for i=1:length(blobs)
                diff = zeros(1, length(group.elements));
                for j=1:length(group.elements)
                    diff(j) = group.elements{j}.matchDiff(blobs(i).pos, frame);
                end
                [~, I] = min(diff);
                objs{end+1} = group.elements{I};
                group.elements(I) = [];
            end
        end

        function ids = getId(group)
            ids = [];
            for i=1:length(group.elements)
                ids = [ids group.elements{i}.getId()];
            end
        end

        function drawRectangle(group)
            ids = group.getId();
            rectangle('Position', group.posList{end},'EdgeColor',[1 1 0], 'linewidth',2);
            text(group.posList{end}(1), group.posList{end}(2), int2str(ids),'Color','blue','FontSize',14);
        end

        function bool = isEmpty(group)
            bool = isempty(group.elements);
        end
    end

end

