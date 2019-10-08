function [keyPointsSet,keyPointsBoundary] = maskComputeKP(I,mask,plotInScript,sizeParam,superFlag)

conn = 8; % set connectivity param
diagParamD = sqrt(2); % set path param for diagnoal connections 
powerParam = 1; % set power factor for weights
deltaS = 1;
deltaM = 1;
pathLengthParamS = 0.2; % in paper it is parameter a

iterControl = -1;

I = im2double(I);

% figure; hold on; imshow(I);

img = maskDetermineWeightImage(I);

img = imresize(img,sizeParam,'Method','bilinear');
mask = imresize(mask,sizeParam,'Method','nearest');

mask = im2bw(mask,0.7);

% figure; hold on; imshow(imresize(-img,5,'nearest'),[]);

keyPointsSet = maskDetermineKeyPointsSET(img,mask,conn,diagParamD,...
        powerParam,deltaS,deltaM,pathLengthParamS,superFlag,iterControl);

keyPointsBoundary = maskDetermineKeyPointsEdges(img,mask);

rows = size(img,1);
cols = size(img,2);  

 keyPointsSet = [keyPointsSet; keyPointsBoundary];
%     keyPointsSet = [keyPointsBoundary];

if(plotInScript == true)
h=figure; imshow(-img,[]); hold on;
for jj=1:length(keyPointsSet)
   plot(keyPointsSet(jj,1),rows-keyPointsSet(jj,2),'.g','MarkerSize',7)
end
    plot(keyPointsBoundary(:,1),rows-keyPointsBoundary(:,2),'.r','MarkerSize',5);
end


% figure; hold on; 
% plot(keyPointsSet(:,1),keyPointsSet(:,2),'*');
end