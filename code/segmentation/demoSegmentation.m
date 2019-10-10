% demo script
clc;clear all;close all;

select = 1; % % can be either 1 or 2; 1 for SET1 and 2 for SET2
input.dbName = 'databases/NTU-Wrist-Demo-Database' % database folder name
input.preProcName = 'SEToriginalWristImages'

maskDoSegmentation(select,input)