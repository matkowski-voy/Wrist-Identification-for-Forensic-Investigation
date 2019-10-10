% demo roi extraction script
clear all; clc; close all;

input.dbName = 'databases/NTU-Wrist-Demo-Database' % database folder name
input.preProcName = 'SETsegmentedWristImages'
setName = {'SET4'}; 
procSelector = false;
maskAlign(procSelector,setName,input)

% setName = {'SET4'}; 
% maskAlign(setName,preProcName,dbName)