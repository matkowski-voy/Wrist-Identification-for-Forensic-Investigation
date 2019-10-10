% demo script build classifiers 
clear all; close all; clc;

featSET.dbName = 'databases/NTU-Wrist-Demo-Database'
setName = {'SET4'}     % SET1/SET1p or SET4/SET4p can be used only
classifierType = {'svm'} % pls or svm can be used only
maskBuildClassifiers(setName,classifierType,featSET)

% setName = {'SET4'}    % SET1/SET1p or SET4/SET4p can be used only
% classifierType = {'svm'} % pls or svm can be used only
% maskBuildClassifiers(setName,classifierType,dbName)