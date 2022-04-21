function drawRectangle(pos, id, color)
    rectangle('Position', pos,'EdgeColor',color, 'linewidth',2);
    text(pos(1), pos(2), int2str(id),'Color','blue','FontSize',14);
end