% maskDetermineGridPoints
function [grid, ind_up, ind_down] = maskDetermineGrid(img,mask,numUpDownBlocks,numLeftRightBlocks,showGrid)
    rows = size(mask,1);
    cols = size(mask,2);
    mask2 = mask;

    j_up = 0;
    j_down = rows;
    tm = 0;
    thresh1 = mean(mean(mask'));
%     thresh1 = 0.75;
    while(tm < thresh1)
        j_up = j_up + 1;
        tm = mean(mask(j_up,:));
        ind_up = j_up;
    end
    tm = 0;
    while(tm < thresh1)
        tm = mean(mask(j_down,:));
        j_down = j_down - 1;
        ind_down = j_down;
    end
%     ind_up = round(rows/8);
%     ind_down = rows - ind_up;
    
    thresh2 = mean(mode(mask(ind_up:ind_down,:)));
    i_left = 0;
    tm = 0;
    while(tm < thresh2)
        i_left = i_left + 1;
        tm = mean(mask(ind_up:ind_down,i_left));
        ind_left = i_left;
    end
    i_right = cols;
    tm = 0;
    while(tm < thresh2)
        i_right = i_right - 1;
        tm = mean(mask(ind_up:ind_down,i_right));
        ind_right = i_right;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    j_up = 0;
    j_down = rows;
    thresh1 = mean(mode(mask(:,ind_left:ind_right)'));
    tm = 0;
    while(tm < thresh1)
        j_up = j_up + 1;
        tm = mean(mask(j_up,ind_left:ind_right));
        ind_up = j_up;
    end
    tm = 0;
    while(tm < thresh1)
        tm = mean(mask(j_down,ind_left:ind_right));
        j_down = j_down - 1;
        ind_down = j_down;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%     horizontal_step = round((ind_down - ind_up)/numUpDownBlocks);
%     vertical_step = round(cols/numLeftRightBlocks);
    horizontal_step = floor((ind_down - ind_up)/numUpDownBlocks);
    vertical_step = floor(cols/numLeftRightBlocks);


    
    ind_up_pre = ind_up;
    ind_up = ind_up - floor((ind_up+numUpDownBlocks*horizontal_step - ind_down)/2); % adjust ind_up such that 
    if(ind_up < 1)
        ind_up = 1;
    end
    % there is a smimilar gap between up and down block
    mask(:,cols+1:vertical_step*numLeftRightBlocks+1) = 0; % padd with zeros
    mask2(:,cols+1:vertical_step*numLeftRightBlocks+1) = 0;
    if(showGrid == true)

    figure;imshow(img); hold on; 
    x1 = ind_up;
    for kk=1:numUpDownBlocks+1
        plot(1:1:vertical_step*numLeftRightBlocks+1,x1,'+k','MarkerSize',2);
        x1 = x1 + horizontal_step;
    end
    x1 = 1;
    for kk=1:numLeftRightBlocks+1
        plot(x1,ind_up:1:ind_up+numUpDownBlocks*horizontal_step,'+k','MarkerSize',2);
        x1 = x1 + vertical_step;
    end
    pause
    end
    
%     indM = 0; 
%     y=1;
%     x = ind_up;
%     switch1 = ones(numUpDownBlocks*numLeftRightBlocks,1);
%     for jj=1:numLeftRightBlocks 
%         x = ind_up;
%         for ii=1:numUpDownBlocks
%             indM = indM + 1;
%             box = mask2(x:x+horizontal_step,y:y+vertical_step);
%             indBox = box(box ~= 0);
%             if(length(indBox) < horizontal_step*vertical_step*r1)
%                switch1(indM) = 0;
%                if(showGrid == true)
%                plot(y+vertical_step/2,x+horizontal_step/2,'*r');
%                end
%             end
%             x = x + horizontal_step;      
%         end
%         y = y + vertical_step;
%     end
    switch1 = 0;
    grid.ind_up = ind_up;
    grid.ind_down = ind_down;
    grid.vertical_step = vertical_step;
    grid.horizontal_step = horizontal_step;
    grid.numLeftRightBlocks = numLeftRightBlocks;
    grid.numUpDownBlocks = numUpDownBlocks;
    grid.cols = cols;
    grid.rows = rows;
    grid.switch1 = switch1;
end