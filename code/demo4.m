% demo script by woy 
% pipeline
% segmentation -> roi_extraction -> feature extraction -> identification
%
% see description of result folders hierarchy in demo3
% comparison scores, classifiers and features in
% results/results/results/

clc;clear all;close all;
run modules_setup

input.dbName = 'databases/NTU-Wrist-Demo-Database' % database folder name
input.preProcName = 'SEToriginalWristImages'

% segment images in SET1 and SET2
select = 1; % % can be either 1 or 2; 1 for SET1 and 2 for SET2
[~]=maskDoSegmentation(select,input);
select = 2; % % can be either 1 or 2; 1 for SET1 and 2 for SET2
[segmented]=maskDoSegmentation(select,input);

% align and extract features from the gallery set (SET1)
% and build classifiers for the gallery SET1
setName = {'SET1'}; 
procSelector = false;
[ROI]=maskAlign(procSelector,setName(1),segmented);
[featSET]=maskBuildFeatureVectors(setName(1),ROI);
maskBuildClassifiers(setName(1),{'svm'},featSET);

% align and extract features from the probe set (SET2)
setName = {'SET2'}; 
procSelector = false;
[ROI]=maskAlign(procSelector,setName(1),segmented);
maskBuildFeatureVectors(setName(1),ROI);

% identification 
maskMatch({'SET1'},{'SET2'},{'svm'},featSET)

