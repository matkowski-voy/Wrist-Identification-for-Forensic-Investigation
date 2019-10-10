function [histMatrix] = maskExtractLBP(F1,grid,binNum,scanVis)
if(scanVis == true)
    figure;
end
numUpDownBlocks = grid.numUpDownBlocks;
numLeftRightBlocks = grid.numLeftRightBlocks;
horizontal_step = grid.horizontal_step;
vertical_step = grid.vertical_step;
ind_up = grid.ind_up;
histMatrix = zeros(numUpDownBlocks*numLeftRightBlocks,binNum);

indM = 0;
y=1;
x = ind_up;
    for jj=1:numLeftRightBlocks 
        x = ind_up;
        for ii=1:numUpDownBlocks
            indM = indM + 1;
            box = F1(x:x+horizontal_step,y:y+vertical_step);
            [histMatrix(indM,:), ~] = histc(box(box ~= 0),1:binNum); % it only happens when scaning window exceeds
                                                                            % region of interes
%             histMatrix(indM,:) = histMatrix(indM,:)/sum(histMatrix(indM,:)); % convert to probability representation                                              
%             histMatrix(indM,:) = histMatrix(indM,:)/(trapz(1:10,histMatrix(indM,:)));
            % figure; bar(histMatrix(indM,:)/sum(histMatrix(indM,:)));
%             length(xx)
%             figure; bar(histMatrix(indM,:)/(trapz(1:10,histMatrix(indM,:))));
%             pause
            if(scanVis == true)
            imshow(F1,[]);hold on;
            plot(y:y+vertical_step,x,'.g','MarkerSize',5);
            plot(y:y+vertical_step,x+horizontal_step,'.g','MarkerSize',5);
            plot(y+vertical_step,x:x+horizontal_step,'.g','MarkerSize',5);
            plot(y,x:x+horizontal_step,'.g','MarkerSize',5);
%             if(grid.switch1(indM) == 0)
%                plot(y:y+vertical_step,x,'.r','MarkerSize',5);
%                plot(y:y+vertical_step,x+horizontal_step,'.r','MarkerSize',5);
%                plot(y+vertical_step,x:x+horizontal_step,'.r','MarkerSize',5);
%                plot(y,x:x+horizontal_step,'.r','MarkerSize',5); 
%             end
            drawnow
            end
            x = x + horizontal_step;  
        end
        y = y + vertical_step;
    end

end