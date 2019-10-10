function dist = maskDetermineWeightImage(I)

    histeqParam = 9;

    y = adapthisteq(I(:,:,1),'NumTiles',[histeqParam histeqParam]);
    [Gx, ~] = imgradientxy(y,'Sobel');
    y = adapthisteq(I(:,:,2),'NumTiles',[histeqParam histeqParam]);
    [Gx1, ~] = imgradientxy(y,'Sobel');
    y = adapthisteq(I(:,:,3),'NumTiles',[histeqParam histeqParam]);
    [Gx2, ~] = imgradientxy(y,'Sobel');

    dist1 = max(abs(Gx),abs(Gx1));
    dist2 = max(dist1,abs(Gx2));
    
    dist = 1-dist2;
    [ii1,jj1]=find(isnan(dist)| isinf(dist));
    indices = sub2ind(size(dist),ii1,jj1);
    dist(indices) = 0;
    
%     figure; imshow(dist,[])
%     pause
    
end