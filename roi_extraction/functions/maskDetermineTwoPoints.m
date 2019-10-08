function [p1, p2] = maskDetermineTwoPoints(paths,dict,yUp,yDown,rows,...
    deltaS,deltaM)
p1 = -1;
p2 = -1;
minPath = inf;
for ii=1:size(yUp,1)
    s1 = dict(rows-yUp(ii,2),yUp(ii,1))+deltaS;
    for jj=1:size(yDown,1)
         m1 = dict(rows-yDown(jj,2),yDown(jj,1))-deltaM;
         P(ii,jj) = paths(s1,m1);
        if(P(ii,jj) < minPath)
            minPath = P(ii,jj);
            p1 = s1;
            p2 = m1;
        end
    end
end
end