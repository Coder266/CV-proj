function res = near_edge(pos, sizex, sizey, th)
    res = abs(pos(1) - 0) < th || abs(pos(1) - sizex) < th || ...
        abs(pos(2) - 0) < th || abs(pos(2) - sizey) < th;
end