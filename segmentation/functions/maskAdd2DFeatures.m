function [labNorm, imgNorm, imgGx, imgGy, laplacian, lapX, lapY ...
    ] = maskAdd2DFeatures(I)
    
    imgRGB = im2double(I);
    hgamma = vision.GammaCorrector(2.5,'Correction','Gamma');
    y = step(hgamma,imgRGB);
    y = rgb2gray(y);
    gray = y;
    y = dog(y,1,2,0);
    a = 0.1;
    t = ones(size(y));
    t = t.*3;
    y = y./(mean(mean(abs(y.^a))))^(1/a);
    y = y./mean((mean(min(t,abs(y))).^a))^(1/a);
    y = t.*tanh(y./t);
    imgNorm = y;
    
    [L, A, B] = RGB2Lab(I(:,:,1),I(:,:,2),I(:,:,3));
    lab(:,:,1) = L;
    lab(:,:,2) = A;
    lab(:,:,3) = B; 
    A = abs(A);
    B = abs(B);
    A = A./(sum(sum(A)));
    B = B./(sum(sum(B)));
    L = L./(sum(sum(abs(L))));
    lambda = 2.2;
    S = sqrt((L - mean(mean(L))).^2 + (lambda.*(A - mean(mean(A)))).^2 + (lambda.*...
        (B - mean(mean(B)))).^2);
    x_min = min(min(S));
    x_max = max(max(S));
    b = 255;
    a = 0;
    S_p = (S - x_min)/(x_max - x_min);
    labNorm = S_p;
    
    [imgGx, imgGy] = imgradientxy(gray);
    
    laplacian = del2(gray);
    
    
    l1 = [0 -1 0; 0 2 0; 0 -1 0];
    l2 = [0 0 0; -1 2 -1; 0 0 0];
    lapX = conv2(gray,l1);
    lapY = conv2(gray,l2);
    lapY(:,1:3) = lapY(:,[6 5 4]);
    lapY(:,end-2:end) = lapY(:,[end-3, end-4 end-5]);
    lapX(1:3,:) = lapX([6 5 4],:);
    lapX(end-2:end,:) = lapX([end-3, end-4 end-5],:);
    lapX = lapX(2:end-1,2:end-1);
    lapY = lapY(2:end-1,2:end-1);
  
end