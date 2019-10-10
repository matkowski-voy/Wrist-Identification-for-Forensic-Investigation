% FEATURE SET EXTRACTION demo script
% implementation by WM Matkowski at NTU, Singapore
% uses LBP code (see functions/LBP_functions/lbp.m) 
% uses DSIFT code from vl_feat library 
% (requires download and instalation of vl_feat library)
% download and easy istall from here: http://www.vlfeat.org/install-matlab.html
%
% Extract feature set and save result in one file into the folder
% 
% please cite the following paper when using this code:
% Wojciech Michal Matkowski, Frodo Kin Sun Chan and Adams Wai Kin Kong. 
% "A Study on Wrist Identification for Forensic Investigation."
% Image and Vision Computing, vol. 88, August 2019, pp 96-112. 
% https://doi.org/10.1016/j.imavis.2019.05.005
%
%
% questions? bugs? email: matk0001@e.ntu.edu.sg and maskotky@gmail.com
% also see in the paper Section 3.3 and Fig. 9

function [ptr]=maskBuildFeatureVectors(setName,ROI)

preProcName = ROI.preProcName;
dbName = ROI.dbName;
ptr.preProcName = 'features';
ptr.dbName = dbName;

addpath(pwd,'functions');
addpath(pwd,'functions/LBP_functions');


% dbName = 'NTU-Wrist-Demo-Database' % database folder name
% setName = {'SET4p'};             % image sets folder names
% preProcName = 'SETsegmentedAlignedWristImages'
saveFeatureSet = true;
showGrid = false; % set true to visualze grids
settings.scanVisLBP = false; % set true to visualize spatial positions and LBP feature maps 

pathImg = fullfile('../',dbName,preProcName,setName{1},'img')
pathMask = fullfile('../',dbName,preProcName,setName{1},'mask')
mkdir(fullfile('../results',dbName,'features',setName{1}))
pathSave = fullfile('../results',dbName,'features',setName{1})
fileI = dir(pathImg); fileI = fileI(3:end);
fileM = dir(pathMask); fileM = fileM(3:end);


%% define grids
numGrids = 7;
numUpDownBlocks1 = 7; % number of blocks in veritcal direcion
numLeftRightBlocks1 = 5; %number of blocks in horizontal direction
numUpDownBlocks2 = 5;
numLeftRightBlocks2 = 7;
numUpDownBlocks3 = 5;
numLeftRightBlocks3 = 5;
numUpDownBlocks4 = 4;
numLeftRightBlocks4 = 3;
numUpDownBlocks5 = 3;
numLeftRightBlocks5 = 4;
numUpDownBlocks6 = 3;
numLeftRightBlocks6 = 3;
numUpDownBlocks7 = 2;
numLeftRightBlocks7 = 2;

numUpDownBlocks = [numUpDownBlocks1 numUpDownBlocks2 numUpDownBlocks3 numUpDownBlocks4 numUpDownBlocks5 numUpDownBlocks6 numUpDownBlocks7 ];
numLeftRightBlocks = [numLeftRightBlocks1 numLeftRightBlocks2 numLeftRightBlocks3 numLeftRightBlocks4 numLeftRightBlocks5 numLeftRightBlocks6 numLeftRightBlocks7 ];
grid = cell(length(numUpDownBlocks),1);

%% build LBP filters
settings.neighb = 8;
settings.mapping1 = getmapping(settings.neighb,'riu2');
settings.mapping2 = getmapping(settings.neighb,'u2');
settings.radius1 = 1;
settings.radius2 = 2;

%feature vector length
numGenFeatures = 16466;
fprintf('number of features: %d\n',numGenFeatures);
Vec = zeros(length(fileI),numGenFeatures+3); % plus target or description

sampleNum = 1;
vec_it = 1;
for i=sampleNum:length(fileI)
    i
    fileI(i).name
    tic
    I = imread(fullfile(pathImg,fileI(i).name));
    mask = imread(fullfile(pathMask,fileM(i).name));
    I = im2double(I);
    mask = im2bw(mask,0.5);
    gray = rgb2gray(I(35:160,:,:));

    % determine the gird parameters
    for jj=1:numGrids
    [grid{jj}, ind_up, ind_down] = maskDetermineGrid(I,mask,...
        numUpDownBlocks(jj),numLeftRightBlocks(jj),showGrid);
    end
    I = padarray(I,[0 2]);
    mask([1:ind_up ind_down:size(mask,1)],:)=0;
    mask = padarray(mask,[0 2]);
    settings.grid = grid;
    C1 = I(:,:,1);
    C2 = I(:,:,2);
    C3 = I(:,:,3);

    mask1 = mask;
    CR1 = C1;
    CG1 = C2; 
    CB1 = C3; 
    
    % extract feature vector
    [fv1] = maskExtract2(CR1,CG1,CB1,mask1,settings,gray);

    % insert feature vector and labels into the matrix (Vec)
    if(fileM(i).name(end-4) == 'L' || fileM(i).name(end-4) == '1')
        Vec(vec_it,:) = [fv1 str2double(fileI(i).name(1:4)) 0 str2double(fileI(i).name(1:4))];
    end
    if(fileM(i).name(end-4) == 'R' || fileM(i).name(end-4) == '2')
        Vec(vec_it,:) = [fv1 str2double(fileI(i).name(1:4)) 1 -str2double(fileI(i).name(1:4))];
    end
    vec_it = vec_it + 1;
    toc
end

if(saveFeatureSet == true)
    save(fullfile(pathSave,strcat('set.mat')),'Vec'); 
    fprintf(strcat('feature set (matrix) saved in mat file: ','set.mat\n'));
    pathSave
end
end