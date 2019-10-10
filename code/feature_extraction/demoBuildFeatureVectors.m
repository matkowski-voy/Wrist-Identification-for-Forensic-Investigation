% demo script build feature sets
clear all; close all; clc;

ROI.dbName = 'databases/NTU-Wrist-Demo-Database'
ROI.preProcName = 'SETsegmentedAlignedWristImages'
setName = {'SET5'}
maskBuildFeatureVectors(setName,ROI)

% setName = {'SET5'}
% maskBuildFeatureVectors(setName)