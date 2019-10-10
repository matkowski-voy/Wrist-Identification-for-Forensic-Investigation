% demo2 script by voy
% pipeline
% roi_extraction -> feature extraction -> identification
%
% results folders hierarchy:
% note that the results of roi_extraction are saved in the folder
% results/databases/NTU-Wrist-Demo-Database/roi_extraction
% feature extraction is performed on image from the above folder
% the extracted features are nested in
% results/results/databases/NTU-Wrist-Demo-Database/features
% the classifiers are nested in
% results/results/databases/NTU-Wrist-Demo-Database/classifiers
% the comparison scores are nested in
% results/results/databases/NTU-Wrist-Demo-Database/scores

clear all; close all; clc;
run modules_setup

input.dbName = 'databases/NTU-Wrist-Demo-Database'
input.preProcName = 'SETsegmentedWristImages'
setGallery = {'SET4'} % SET1/SET1p or SET4/SET4p can be used only
setProbe = {'SET5'}   % SET2/SET2p, SET3/SET3p and SET5/SET5p can be used only
classifierType = {'pls'} % pls or svm can be used only

% EXTRACT ROI (ALIGN)
% using two procedures. SET4, SET4p and SET5 and SET5p are created
procSelector = false;
maskAlign(procSelector,setGallery,input)
maskAlign(procSelector,setProbe,input)
procSelector = true;
maskAlign(procSelector,setGallery,input)
ROI=maskAlign(procSelector,setProbe,input)


setGallery = {'SET4','SET4p'}                   
setProbe = {'SET5','SET5p'}                      
%% EXTRACT AND SAVE FEATURE SETS
for i = 1:length(setGallery)
    maskBuildFeatureVectors(setGallery(i),ROI)
    featSET=maskBuildFeatureVectors(setProbe(i),ROI);
end

%% BUILD PLS AND SVM CLASSIFIERS
for i = 1:length(setGallery)
    for j = 1:length(classifierType)
    maskBuildClassifiers(setGallery(i),classifierType(j),featSET);
    end
end

%% IDENTIFICATION (CALCULATE COMPARISON SCORES)
for i = 1:length(setGallery)
    for j = 1:length(classifierType)
    maskMatch(setGallery(i),setProbe(i),classifierType(j),featSET)
    end
end
