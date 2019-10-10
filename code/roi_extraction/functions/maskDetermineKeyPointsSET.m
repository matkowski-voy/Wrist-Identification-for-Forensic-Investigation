function p = maskDetermineKeyPointsSET(img,mask,conn,diagParamD,...
        powerParam,deltaS,deltaM,pathLengthParamS,superFlag,iterControl)

% determine wrist edges
stopFlag = false;
rows = size(img,1);
cols = size(img,2);
[Y] = maskDetermineEdges(mask*255);
yUp = Y(1:cols,:);
yDown = Y(cols+1:end,:);
yUp = yUp((yUp(:,2) < (rows-1)),:);
yDown = yDown((yDown(:,2) > 1),:);
maskProcess = mask;  

% setup the params
p = [];
keyPoints = [];

while(~stopFlag)

    keyPoints = maskDetermineKeyPoints(img,mask,conn,diagParamD,...
        powerParam,deltaS,deltaM,pathLengthParamS,superFlag);
    fprintf('.....key points.....\n');
    iterControl = iterControl + 1;
    p=[p; keyPoints]; %#ok<AGROW>
    rowX = p(:,1)';
    colX = p(:,2)';
    indices = sub2ind(size(mask),rows-colX,rowX);
    maskProcess(indices) = 0;
    mask = imerode(maskProcess,strel('disk',1));
%     figure; hold on; imshow(mask);
    rowX = Y(:,1)';
    colX = Y(:,2)';
    indices = sub2ind(size(mask),rows-colX,rowX);
    mask(indices) = 1;

    if(iterControl > 0)
        stopFlag = true;
    end

end % end o while

end