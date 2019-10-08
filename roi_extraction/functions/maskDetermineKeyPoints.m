%% determine key points on wrist image
function keyPoints = maskDetermineKeyPoints(I,mask,conn, ...
    diagParamD,powerParam,deltaS,deltaM,pathLengthParamS,superFlag)
fprintf(':determining key points\n')

keyPoints = [];
rows = size(I,1);
cols = size(I,2);
% determine the upper and lower edge cordinates points
[Y] = maskDetermineEdges(mask*255);
yUp = Y(1:cols,:);
yDown = Y(cols+1:end,:);
yUp = yUp((yUp(:,2) < (rows-1)),:);
yDown = yDown((yDown(:,2) > 1),:);
% set the dictionary for edges points
dict = 1:1:rows*cols;
dict = reshape(dict,rows,cols);


% build graph
% figure; imshow(I,[]);
% pause
G = maskBuildGraph(I,mask,conn,diagParamD,powerParam);

% find all shortest path in graph using Johnsons alg O(N*log(N)+N*E)
paths = graphallshortestpaths(G);
% size(dict)
% size(paths)
[p1, p2] = maskDetermineTwoPoints(paths,dict,yUp,yDown,rows,deltaS,deltaM);

[z1, z2] = maskSetKeyPoints(dict,[p1 p2],rows); 

% find shortest path in the graph
if(p1 > 0 && p2 > 0)
    [dist1, pathOrg, pred] = graphshortestpath(G, p1,p2,'Method','Dijkstra');
    [kp1, kp2] = maskSetKeyPoints(dict,pathOrg,rows);
    
    % SUPER FLAG OPTION % in paper Proc2 Proc2/3 selection
    if(superFlag == true)
        keyPoints = [kp1; kp2]';
    end
    
    pathCond = dist1/length(pathOrg);
end


minDist = inf;
if(superFlag == false)
    fprintf('---:computing paths for close points loop\n');
for ii=deltaS:1:round(length(pathOrg)*pathLengthParamS)
    for jj=deltaM:1:round(length(pathOrg)*pathLengthParamS)
    [p1, p2] = maskDetermineTwoPoints(paths,dict,yUp,yDown,rows,ii,jj);
    if(p1 > 0 & p2 > 0)
        [dist, path, pred] = graphshortestpath(G, p1,p2,'Method','Dijkstra');
        dist = dist/length(path);
        if((dist <= pathCond) && (dist <= minDist))
            minDist = dist;
            [xpp, ypp] = maskSetKeyPoints(dict,path,rows); 
        end
    end
    end
end
end

if(superFlag == true)
keyPoints = unique(keyPoints,'rows');
else
keyPoints = unique([keyPoints; [xpp; ypp]'],'rows');
end

end %endOfFun