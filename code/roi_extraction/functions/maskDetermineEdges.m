function [Y] = maskDetermineEdges(I)
    y = size(I,1);
    x = size(I,2);
    y_up = [];
    y_down = [];
    for k=1:x
        vert = 0;
        stop = false;
        while(~stop)
            vert = vert + 1;
            if(I(vert,k) == 255 | vert == y)
                y_up(k) = y - vert;
                stop = true;
            end
        end
    end
    for k=1:x
       vert = y + 1;
        stop = false;
        while(~stop)
            vert = vert-1;
            if(vert >= 1)
            if(I(vert,k) == 255)
                y_down(k) = y - vert;
                stop = true;
            end
            else
                stop = true;
                y_down(k) = 1;
            end
        end 
    end
    Y = [1:1:x 1:1:x; y_up y_down]';
end