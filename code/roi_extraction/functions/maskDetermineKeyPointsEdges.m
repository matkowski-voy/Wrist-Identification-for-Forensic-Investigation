function p = maskDetermineKeyPointsEdges(img,mask)

rows = size(img,1);
cols = size(img,2);  
[Y] = maskDetermineEdges(mask*255);
yUp = Y(1:cols,:);
yDown = Y(cols+1:end,:);
yUp = yUp((yUp(:,2) < (rows-1)),:);
yDown = yDown((yDown(:,2) > 1),:);

p = [yUp;yDown];

end