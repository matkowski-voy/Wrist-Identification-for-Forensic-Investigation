function [xpp, ypp] = maskSetKeyPoints(dict,path,rows)
ypp = zeros(1,length(path));
xpp = zeros(1,length(path));
for jj=1:length(path)
    [ypp(jj), xpp(jj)] = find(dict == path(jj));
     ypp(jj) = rows-ypp(jj);
end
end