% WRIST SKIN SEGMENTATION script
% implementation by WM Matkowski at NTU, Singapore
% uses SLIC code (see slic.m)
% Classify image set and save result into the folders
% 
% please cite the following paper when using this code:
% Wojciech Michal Matkowski, Frodo Kin Sun Chan and Adams Wai Kin Kong. 
% "A Study on Wrist Identification for Forensic Investigation."
% Image and Vision Computing, vol. 88, August 2019, pp 96-112. 
% https://doi.org/10.1016/j.imavis.2019.05.005
%
% 
% questions? bugs? email: matk0001@e.ntu.edu.sg and maskotky@gmail.com
% also see in the paper Section 3.1 and Fig. 4

clc;clear all;close all;

dbName = 'NTU-Wrist-Image-Database-v1' % database folder name
setName = {'SET1','SET2'};             % image sets folder names
addpath(pwd,'classifiersTrees');       % folder contsins ensemble of trees classifier
addpath(pwd,'functions');              % folder contains functions

write2File = true; % saves results
plotFig = false;    % plots some figs and superpixels
select = 1; % can be either 1 or 2; 1 for SET1 and 2 for SET2
sampleNum = 1;             % start from "sampleNum"-th sammple 
imageNominalRowSize = 200; % image height 
superPixelNum = 200;       % number of superpixels to generate
                           % (superpixels algorithm parameter)
regionProperties = {'PixelIdxList','Area','Centroid'};
m = 8;     %8     %Weighting factor between colour and spatial
                  % differences (superpixels algorithm parameter)
if(exist('Ensemble2_100_0110.mat')==0)
end

if(select == 1)
pathImg = fullfile('../databases',dbName,'SEToriginalWristImages',setName{1})
mkdir(fullfile(pwd,'results',dbName,'segmentation',setName{1},'img'))
mkdir(fullfile(pwd,'results',dbName,'segmentation',setName{1},'mask'))
pathSave = fullfile(pwd,'results',dbName,'segmentation',setName{1},'img')
pathSave2 = fullfile(pwd,'results',dbName,'segmentation',setName{1},'mask')
tic
if(exist('Ensemble2_100_0110.mat')==0)
   fprintf('you need to download the trained classifier and paste it into classifiersTree folder\n'); 
end
fprintf('loading ensemble of trees classifier...(can take 40-60 sec)\n');
load Ensemble2_100_0110.mat 
EoT = Ensemble2;
toc
end
if(select == 2)
pathImg = fullfile('../databases',dbName,'SEToriginalWristImages',setName{2})
mkdir(fullfile(pwd,'results',dbName,'segmentation',setName{2},'img'))
mkdir(fullfile(pwd,'results',dbName,'segmentation',setName{2},'mask'))
pathSave = fullfile(pwd,'results',dbName,'segmentation',setName{2},'img') 
pathSave2 = fullfile(pwd,'results',dbName,'segmentation',setName{2},'mask')
tic
if(exist('Ensemble1_100_0110.mat')==0)
   fprintf('you need to download the trained classifier and paste it into classifiersTree folder\n'); 
end
fprintf('loading ensemble of trees classifier...(can take 40-60 sec)\n');
load Ensemble1_100_0110.mat Ensemble1
EoT = Ensemble1;
toc
end
files = dir(pathImg); files = files(3:end);

tic
for i = sampleNum:length(files)
    
    i
    imgRGBnorm = [];
    binaryMask = [];
    I = imread(fullfile(pathImg, files(i).name));
    I = imresize(I,[imageNominalRowSize, NaN]);
    fprintf('file: %s\n', files(i).name);
    imgRGB = I;
    binaryCropMask = ones(size(imgRGB));
    I_segmented = imgRGB;
    if(plotFig == true)
        figure; hold on; imshow(imgRGB); title('original RGB');
    end
    imgHSV = rgb2hsv(imgRGB);
    imgLAB = rgb2lab(imgRGB);
    imgXYZ = rgb2xyz(imgRGB);
    imgYCBCR = rgb2ycbcr(imgRGB);
    imgYIQ = rgb2ntsc(imgRGB);
    imgGray = rgb2gray(imgRGB);
    imgRGB = im2double(imgRGB);
    imgYCBCR = im2double(imgYCBCR);
    nrows = size(imgRGB,1);
    ncols = size(imgRGB,2);
    
    imgRGBnorm(:,:,1) = imgRGB(:,:,1)./sqrt((imgRGB(:,:,1) ...
        .^2+imgRGB(:,:,2).^2+imgRGB(:,:,3).^2));
    imgRGBnorm(:,:,2) = imgRGB(:,:,2)./sqrt((imgRGB(:,:,1) ...
        .^2+imgRGB(:,:,2).^2+imgRGB(:,:,3).^2));
    imgRGBnorm(:,:,3) = imgRGB(:,:,3)./sqrt((imgRGB(:,:,1) ...
        .^2+imgRGB(:,:,2).^2+imgRGB(:,:,3).^2));
    
    %% apply SLIC algorithm for generating superpixels
    tic
    fprintf('running slic algorithm...\n');
    [l, Am, Sp, d] = slic(I, superPixelNum, m, 1, 'mean');
    toc
    %% count region properties
    stats = regionprops(l,regionProperties);
    
    if(plotFig == true)
    figure; hold on; imshow(drawregionboundaries(l,I,[255 255 255])); 
    end
     
    [rowN,colN] = find(Am); %find index in sparse matrix
   %% creates feature vectors  
   tic
   fprintf('extracting features...\n');
   [imgVec, stats] = ...
        maskCreateFeatureVector3(stats, imgRGB, imgRGBnorm, imgLAB,...
        imgHSV, imgYCBCR, imgYIQ,binaryCropMask,rowN,colN,true);
    toc
    
    tic
    fprintf('classyfing superpixels...\n');
    [label,score] = predict(EoT ,imgVec);
    toc

    % creates binary mask based on classifier predictions
    for p = 1:numel(stats)
        if(isequal(label{p},'skin'))
            binaryMask(stats(p).PixelIdxList) = 255;
        else
            binaryMask(stats(p).PixelIdxList) = 0;
        end
    end
    
binaryMask = reshape(binaryMask,size(imgRGB,1),size(imgRGB,2));
h = 20; %% smoothen parameter
binaryMask = maskSmoothenMask(binaryMask,h); % comment if buggy...

% plot and write 2 files      

    rI3 = I_segmented(:,:,1);
    gI3 = I_segmented(:,:,2);
    bI3 = I_segmented(:,:,3);
    rI3(binaryMask == 0) = 0;
    gI3(binaryMask == 0) = 0;
    bI3(binaryMask == 0) = 0;
    I_segmented(:,:,1) = rI3;
    I_segmented(:,:,2) = gI3;
    I_segmented(:,:,3) = bI3;
    if(plotFig == true)
    figure; hold on; imshow(I_segmented); title('segmented by Tree');
    end

if(plotFig == true)
        figure; hold on; imshow(binaryMask); title('bin Tree');
        pause
end
if(write2File == true)
   
        name = strcat(files(i).name(1:end-4),'_binTree.jpg');
        imwrite(I_segmented,fullfile(pathSave,name),'Quality',100);
        imwrite(binaryMask,fullfile(pathSave2,name),'Quality',100);
        display('image segmented by Ensemble of Trees created and saved\n');
 
end

end
toc