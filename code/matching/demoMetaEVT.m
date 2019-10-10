% demo script meta recognition
clear all; close all; clc;

featSET.dbName = 'NTU-Wrist-Demo-Database'
setProbe = {'SET5','SET5p'};           % SET2/SET2p, SET3/SET3p and SET5/SET5p can be used only
classifierType = {'svm','pls'}; 
maskMetaEVT(setProbe,classifierType,featSET)