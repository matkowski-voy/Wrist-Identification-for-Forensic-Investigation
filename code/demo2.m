% demo script by voy
% pipeline
% feature extraction -> identification -> meta-recognition

clear all; close all; clc;
run modules_setup

input.dbName = 'databases/NTU-Wrist-Demo-Database';
input.preProcName = 'SETsegmentedAlignedWristImages'
setGallery = {'SET4','SET4p'}                    % SET1/SET1p or SET4/SET4p can be used only
setProbe = {'SET5','SET5p'}                      % SET2/SET2p, SET3/SET3p and SET5/SET5p can be used only
classifierType = {'pls','svm'} % pls or svm can be used only

%% EXTRACT AND SAVE FEATURE SETS
for i = 1:length(setGallery)
    maskBuildFeatureVectors(setGallery(i),input)
    featSET=maskBuildFeatureVectors(setProbe(i),input)
end

%% BUILD PLS AND SVM CLASSIFIERS
for i = 1:length(setGallery)
    for j = 1:length(classifierType)
    maskBuildClassifiers(setGallery(i),classifierType(j),featSET)
    end
end

%% IDENTIFICATION (CALCULATE COMPARISON SCORES)
for i = 1:length(setGallery)
    for j = 1:length(classifierType)
    maskMatch(setGallery(i),setProbe(i),classifierType(j),featSET)
    end
end

%% META-RECOGNITION
maskMetaEVT(setProbe,classifierType,featSET)