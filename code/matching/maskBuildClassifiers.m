% BUILD WRIST CLASSIFIERS/MODELS demo script
% implementation by WM Matkowski at NTU, Singapore
%
% build pls or svm classifiers/models using one-against-all approach
% 
% please cite the following paper when using this code:
% Wojciech Michal Matkowski, Frodo Kin Sun Chan and Adams Wai Kin Kong. 
% "A Study on Wrist Identification for Forensic Investigation."
% Image and Vision Computing, vol. 88, August 2019, pp 96-112. 
% https://doi.org/10.1016/j.imavis.2019.05.005
%
% in the paper, see Section 3.4
% 
% 
% questions? bugs? email: matk0001@e.ntu.edu.sg and maskotky@gmail.com

function []=maskBuildClassifiers(setName,classifierType,featSET)
dbName = featSET.dbName;
addpath(pwd,'functions'); 

% dbName = 'NTU-Wrist-Demo-Database' % database folder name
% setName = {'SET4'};                    % SET1/SET1p or SET4/SET4p can be used only
% classifierType = {'pls'}; % pls or svm can be used only
saveClassifier = true;
kParam = 5; % PLS parameter - number of latent components

pathSet = fullfile('../results',dbName,'features',setName{1})
mkdir(fullfile('../results',dbName,'classifiers',setName{1},classifierType{1}));
pathSave = fullfile('../results',dbName,'classifiers',setName{1},classifierType{1})

A = importdata(fullfile(pathSet,'set.mat'));
size(A)
A(isnan(A)==1) = 0;                   
labels = unique(A(:,end));
fprintf('building %d classifiers\n',length(labels))
for i=1:length(labels)
i
     indPos = (A(:,end) == labels(i));
     positive = A(indPos,:); % select only positive features form the same wrist
     negative = A(~indPos,:); % choose only negative features 

     if(size(positive,1) >= 1)
         dataPosTrain = positive(:,1:end-3);
         dataNegTrain = negative(:,1:end-3);

         X = [dataPosTrain;dataNegTrain];
         Y = [ones(size(dataPosTrain,1),1); ones(size(dataNegTrain,1),1)*-1];
    % standarize
         [X, xMu, xSigma] = zscore(X);
         [Y, yMu, ySigma] = zscore(Y);

tic
    if(strcmp(classifierType{1},'svm'))
         svmModel = fitcsvm(X,Y,'KernelFunction','linear');  
         b = svmModel.Beta;
         bias = svmModel.Bias;
    end
    if(strcmp(classifierType{1},'pls'))
          b = pls(X,Y,kParam);
          bias = 0;
    end
toc

          if(saveClassifier == true)
          save(fullfile(pathSave,strcat('classifier',num2str(labels(i)),'.mat')),...
                'b','bias','xMu','xSigma','yMu','ySigma')
          fprintf('classifier saved\n')
          end    
     end
   
end
toc
fprintf('results saved in\n')
pathSave
end