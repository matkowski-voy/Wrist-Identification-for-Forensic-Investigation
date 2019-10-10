% demo script matching and plot cmc
clear all; close all; clc;

featSET.dbName = 'databases/NTU-Wrist-Demo-Database'
setGallery = {'SET4'}                    % SET1/SET1p or SET4/SET4p can be used only
setProbe = {'SET5'}                      % SET2/SET2p, SET3/SET3p and SET5/SET5p can be used only
classifierType = {'svm'} % pls or svm can be used only

maskMatch(setGallery,setProbe,classifierType,featSET)