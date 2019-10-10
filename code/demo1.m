% demo script by voy
% pipeline
% feature extraction -> identification
clear all; close all; clc;
run modules_setup

input.dbName = 'databases/NTU-Wrist-Demo-Database'
input.preProcName = 'SETsegmentedAlignedWristImages'
setGallery = {'SET4'}                    % SET1/SET1p or SET4/SET4p can be used only
setProbe = {'SET5'}                      % SET2/SET2p, SET3/SET3p and SET5/SET5p can be used only

maskBuildFeatureVectors(setProbe,input)
maskBuildFeatureVectors(setGallery,input)

classifierType = {'svm'} % pls or svm can be used only
maskBuildClassifiers(setGallery,classifierType,input)

maskMatch(setGallery,setProbe,classifierType,input)