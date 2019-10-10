% WRIST IDENTIFICATION demo script
% implementation by WM Matkowski at NTU, Singapore
%
% identification (one to many comparison) employing classifiers,
% plot CMC curve and save results to folder
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

function [results]=maskMatch(setGallery,setProbe,classifierType,featSET)
dbName = featSET.dbName;
% dbName = 'NTU-Wrist-Demo-Database' % database folder name
% setGallery = {'SET4'};                    % SET1/SET1p or SET4/SET4p can be used only
% setProbe = {'SET5'};                      % SET2/SET2p, SET3/SET3p and SET5/SET5p can be used only
% classifierType = {'svm'}; % pls or svm can be used only


pathSet = fullfile('../results',dbName,'features',setProbe{1})
tic
fprintf('loading probe set\n')
A = importdata(fullfile(pathSet,'set.mat'));
toc
mkdir(fullfile('../results',dbName,'scores',setProbe{1},classifierType{1}));
pathSave = fullfile('../results',dbName,'scores',setProbe{1},classifierType{1})

pathClassifiers= fullfile('../results',dbName,'classifiers',setGallery{1},classifierType{1})
tic
fprintf('loading classifiers\n')
classifier = dir(pathClassifiers); classifier = classifier(3:end);
numClassifiers = length(classifier)
descritpionNum = 3;
numFeatures = size(A,2)-descritpionNum; % -3 because last 3 cols is a description part
betaM = zeros(numFeatures,numClassifiers);
bias = zeros(numClassifiers,1);
x_mu = zeros(numFeatures,numClassifiers);
y_mu = zeros(1,numClassifiers);
x_sigma = zeros(numFeatures,numClassifiers);
y_sigma = zeros(1,numClassifiers);
DictClass = zeros(1,numClassifiers);

for i=1:numClassifiers
    load(fullfile(pathClassifiers,classifier(i).name))
    betaM(:,i) =b;
    bias(i) = bias;
    x_mu(:,i) = xMu;
    xSigma(xSigma == 0) = 1;
    x_sigma(:,i) = xSigma;
    y_mu(i) = yMu;
    y_sigma(i) = ySigma;
   c1 = strfind(classifier(i).name,'.');
   DictClass(i) = str2double(classifier(i).name(11:c1-1));
end
toc

% shuffle probe set
rng(3);
iter = randperm(size(A,1));
A = A(iter,:);
data = A(:,1:end-descritpionNum);
DictData = A(:,end);
errT = 0;

data(isnan(data)==1) = 0;

tic
s = cell(size(data,1),1);
sSamePerson = cell(size(data,1),1);
respVec = zeros(size(data,1),numClassifiers);


for kk=1:size(data,1)
kk

%     data_in = repmat(data(kk,:),numClassifiers,1);
%     dataTest = (data_in-x_mu')./x_sigma';
%     response = betaM'*dataTest';
%     response = diag(response)+bias';
    data_in = (data(kk,:)-x_mu(:,1)')./x_sigma(:,1)';
    response = betaM'*data_in';
    response = response + bias';
    respVec(kk,:) = response;
    [~,ind_r] = sort(response,'descend');
    s{kk} = find(DictData(kk) == unique(DictClass(ind_r),'stable'));

    z = s{kk}; 
    if(numel(z) == 0)
        z = 0;
    end
    current_rank = z(1)
end
toc

rankPP = zeros(1,size(data,1));
z = zeros(1,size(data,1));
for ii=1:size(data,1)
    z = s{ii};
    if(numel(z) == 0)
        z = 0;
    end
    rankPP(ii) = z(1);
end

for i=1:length(rankPP)
  cmc(i)=length(rankPP(rankPP <= i))/length(rankPP);
end

figure; plot(cmc,'-r.');
xlabel('Rank');
ylabel('Identification Rate (%)');
fig_title = strcat(setGallery,'-',setProbe','-',classifierType');
title(fig_title)
% axis([1 min(30,length(cmc)) min(cmc) max(cmc(1:min(30,length(cmc))))])

results.scores = respVec;
results.DictData = DictData;
results.DictClass = DictClass;
results.setGallery=setGallery
results.setProbe=setProbe 
results.classifierType=classifierType
results.dbName=dbName
results.cmc = cmc;
save(fullfile(pathSave,'results.mat'),'results');
fprintf('results ans comparison scores saved in\n');
pathSave
end
