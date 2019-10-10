%% non-parametric kernel regression 2 smoothen image
function I2 = maskSmoothenMask(I,h)
    y = size(I,1);
    x = size(I,2);
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
            if(I(vert,k) == 255 | vert == 1)
                y_down(k) = y - vert;
                stop = true;
            end
        end 
    end
    
%     figure; hold on;
%     plot(y_up);
%     plot(y_down);
    
    block = false;
    hister = 1;
    slopeDown = false;
    slopeUp = false;
    gradChange = false;
    Th = 1;
    for k=1:x-1
    grad(k) = y_up(k) - y_up(k+1);
    end
%     figure; hold on; plot(grad); title('grad');
    ind = 0;
    u_up = 1:1:x;
    for j=1:1:x
        ind  = ind + 1;
        E1_up = 0;
        E2_up = 0;
        for k=1:1:x
            if(abs(u_up(k)-j)/h )<=0.5
                E1_up = E1_up +y_up(k);
                E2_up = E2_up + 1;
            end
        end
        est_up(ind) = E1_up/E2_up;
    end
    
    ind = 0;
    u_down = 1:1:x;
    for j=1:1:x
        ind  = ind + 1;
        E1_down = 0;
        E2_down = 0;
        for k=1:1:x
            if(abs(u_down(k)-j)/h )<=0.5
                E1_down = E1_down +y_down(k);
                E2_down = E2_down + 1;
            end
        end
        est_down(ind) = E1_down/E2_down;
    end
    
    est_up = round(est_up);
    est_down = round(est_down);
    limit_down = y-est_up;
    limit_up = y - est_down;
    
    for j=1:x
       I2(limit_down(j):limit_up(j),j) = 255;
       I2(1:limit_down(j)-1,j) = 0;
       I2(limit_up(j)+1:y,j) = 0;
    end
    
%     figure; hold on;
%     plot(y_up);
%     plot(y_down);
    

end