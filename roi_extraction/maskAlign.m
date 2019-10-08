% WRIST ALIGNMENT script
% implementation by WM Matkowski at NTU, Singapore
% uses CPD code (see CPD2 folder) need to compile CPD before, add to path
% and then run cpd_make
% 
% please cite the following paper when using this code:
% Wojciech Michal Matkowski, Frodo Kin Sun Chan and Adams Wai Kin Kong. 
% "A Study on Wrist Identification for Forensic Investigation."
% Image and Vision Computing, vol. 88, August 2019, pp 96-112. 
% https://doi.org/10.1016/j.imavis.2019.05.005
%
% in the paper, see Section 3.2, Algorithms 1,2 and 3 and Figs. 5, 6, 7 and 8
% 
% 
% questions? bugs? email: matk0001@e.ntu.edu.sg and maskotky@gmail.com

clear all; clc; close all;

addpath(pwd,'keyPointsTemplate'); 
addpath(pwd,'CPD2'); 
addpath(pwd,'functions'); 
% run cpd_make % you need to uncomment this line to compile cpd lib (only once)

dbName = 'NTU-Wrist-Image-Database-v1' % database folder name
setName = {'SET2'};                    % image sets folder names

% set paths
pathImg = fullfile('../databases',dbName,'SETsegmentedWristImages',setName,'img')
pathBinMask = fullfile('../databases',dbName,'SETsegmentedWristImages',setName,'mask')
pathImg = pathImg{1}; pathBinMask = pathBinMask{1};
filesI = dir(pathImg); filesI = filesI(3:end);
filesM = dir(pathBinMask); filesM = filesM(3:end);
mkdir(fullfile(pwd,'results',dbName,'roi_extraction',setName{1},'img'));
mkdir(fullfile(pwd,'results',dbName,'roi_extraction',setName{1},'mask'));
pathSave = fullfile(pwd,'results',dbName,'roi_extraction',setName,'img')
pathSaveMask = fullfile(pwd,'results',dbName,'roi_extraction',setName,'mask')
pathSave = pathSave{1}; pathSaveMask=pathSaveMask{1};
% load key points template
load leftT2.mat leftTemplate
keyPointsTemplate = leftTemplate;

% parameters od CPD algorithm
opt.viz=0; 
opt.outliers=0.5;
opt.method='rigid';
opt.normalize=1;
opt.corresp=1;
opt.max_it=300;     
opt.tol=1e-8;

% parameters from the paper
procSelector = false; % select true or false for either proc2 or proc2/3 for alignment
sizeParam = 0.2; % set image resizing factor (40 pixels height)

plotFlag = true;
plotInScript = false;
if(plotFlag == true)
plotInScript = true;
end
saveResults = false;

sampleNum =1;

for i=sampleNum:length(filesM)
i
I = imread(fullfile(pathImg, filesI(i).name));
mask = imread(fullfile(pathBinMask, filesM(i).name));
filesI(i).name

if(plotFlag == true)
figure; imshow(I); 
end
sizeParam
keyPointsSet = maskComputeKP(I,mask,plotInScript,sizeParam,procSelector);
    
I2 = zeros(200,125);
Ismall = imresize(I2,sizeParam);
I2small = imresize(I2,sizeParam);
keyPointsSet(:,2) = size(Ismall,1)-keyPointsSet(:,2);    

% do CPD registration 
[Transform, Correspondence] = cpd_register(keyPointsTemplate,keyPointsSet,opt);
 
transMatrix(1,1) = Transform.R(1,1)*Transform.s;
transMatrix(2,1) = Transform.R(1,2)*Transform.s;
transMatrix(1,2) = Transform.R(2,1)*Transform.s;
transMatrix(2,2) = Transform.R(2,2)*Transform.s;
transMatrix(3,1) = Transform.t(1)/sizeParam;
transMatrix(3,2) = Transform.t(2)/sizeParam;
transMatrix(:,3) = [0; 0; 1];

tabH(i) = transMatrix(3,1);
tabH2(i) = Transform.s;
if(transMatrix(3,1) > size(I,2)/4)
    transMatrix(3,1) = size(I,2)/4;
    tabH(i) = size(I,2)/4;
end
if(transMatrix(3,1) < -size(I,2)/4)
    transMatrix(3,1) = -size(I,2)/4;
    tabH(i) = -size(I,2)/4;
end

tform_mat = affine2d(transMatrix);

R1 = imref2d(size(I));
R2 = imref2d(size(I2));
R1small = imref2d(size(Ismall));
R2small = imref2d(size(I2small));
[outputImage, Rc] = imwarp(I,R1,tform_mat,'cubic','outputView',R2);
[outputImageMask, Rc] = imwarp(mask,R1,tform_mat,'cubic','outputView',R2);

T=cpd_transform(keyPointsSet,Transform);



if(plotFlag == true)
h=figure;  imshow(outputImage); hold on;
plot(T(:,1)/sizeParam,T(:,2)/sizeParam,'r.');title('T');
plot(keyPointsTemplate(:,1)/sizeParam,keyPointsTemplate(:,2)/sizeParam,'g.')
figure;  imshow(I); hold on;
plot(keyPointsSet(:,1)/sizeParam,keyPointsSet(:,2)/sizeParam,'*','MarkerSize',3);title('set 1');
figure; imshow(outputImage); hold on;
plot(25,1:1:200,'.r');
plot(101,1:1:200,'.r');
end
outputImage = outputImage(:,25:101,:);
outputImageMask = outputImageMask(:,25:101);


if(plotFlag == true)
    figure; imshow(outputImage); hold on;
    pause
    close all;
end
if(saveResults == true)
name = strcat(filesI(i).name);
imwrite(outputImage,fullfile(pathSave,name),'Quality',100);
imwrite(outputImageMask,fullfile(pathSaveMask,name),'Quality',100);
end

end
