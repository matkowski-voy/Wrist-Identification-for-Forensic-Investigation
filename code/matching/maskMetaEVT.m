% WRIST META RECOGNITION demo script
% implementation by WM Matkowski at NTU, Singapore
%
% EVT
% 
% please cite the following paper when using this code:
% Wojciech Michal Matkowski, Frodo Kin Sun Chan and Adams Wai Kin Kong. 
% "A Study on Wrist Identification for Forensic Investigation."
% Image and Vision Computing, vol. 88, August 2019, pp 96-112. 
% https://doi.org/10.1016/j.imavis.2019.05.005
%
% in the paper, see Section 3.5
% 
% 
% questions? bugs? email: matk0001@e.ntu.edu.sg and maskotky@gmail.com

function []= maskMetaEVT(setProbe,classifierType,featSET)
dbName = featSET.dbName;
% dbName = 'NTU-Wrist-Demo-Database'; % database folder name
% setProbe = {'SET5','SET5p'};           % SET2/SET2p, SET3/SET3p and SET5/SET5p can be used only
% classifierType = {'svm','pls'}; 

pathMeta1 = fullfile('../results',dbName,'scores',setProbe{1},classifierType{1});
pathMeta2 = fullfile('../results',dbName,'scores',setProbe{2},classifierType{2});
pathMeta3 = fullfile('../results',dbName,'scores',setProbe{1},classifierType{2});
pathMeta4 = fullfile('../results',dbName,'scores',setProbe{2},classifierType{1});

load(fullfile(pathMeta1,'results.mat'))
DictData = results.DictData;
DictClass = results.DictClass;
sys1 = gather(results.scores);

load(fullfile(pathMeta2,'results.mat'))
DictData2 = results.DictData;
DictClass2 = results.DictClass;
sys2 = gather(results.scores);

load(fullfile(pathMeta3,'results.mat'))
DictData3 = results.DictData;
DictClass3 = results.DictClass;
sys3 = gather(results.scores);

load(fullfile(pathMeta4,'results.mat'))
DictData4 = results.DictData;
DictClass4 = results.DictClass;
sys4 = gather(results.scores);

%% DEFINE some params
n = 1; % number of hypotized outliers (number of best scores)
tailFactor = .2; % fraction of the gallery size that will determine tail's length
n2 = round(size(DictClass,2)*tailFactor); % tail's length
cntx1 = 0; 
cntx2 = 0;
cntx3 = 0;
cntx4 = 0;

tic
for i=1:size(sys1,1)

    data1 = sys1(i,:)+abs(min(sys1(i,:)));
    data2 = sys2(i,:)+abs(min(sys2(i,:)));
    data3 = sys3(i,:)+abs(min(sys3(i,:)));
    data4 = sys4(i,:)+abs(min(sys4(i,:)));

    [data1,ind_r1] = sort(data1,'descend');
    [data2,ind_r2] = sort(data2,'descend');
    [data3,ind_r3] = sort(data3,'descend');
    [data4,ind_r4] = sort(data4,'descend');

    parmhat1 = wblfit(data1(1+n:n2));
    parmhat2 = wblfit(data2(1+n:n2));
    parmhat3 = wblfit(data3(1+n:n2));
    parmhat4 = wblfit(data4(1+n:n2));
% compute CDF for the hypotized outlier
    c1(i) = cdf('Weibull',data1(1),parmhat1(1),parmhat1(2));
    c2(i) = cdf('Weibull',data2(1),parmhat2(1),parmhat2(2));
    c3(i) = cdf('Weibull',data3(1),parmhat3(1),parmhat3(2));
    c4(i) = cdf('Weibull',data4(1),parmhat4(1),parmhat4(2));

% find the one which is the most likely to be outlier and return
% its index ind_s 
    [zzz(i),ind_s] = max([c1(i) c2(i) c3(i) c4(i)]);

    if(ind_s == 1)
       ind_ = ind_r1;
       s{i} = find(DictData(i) == unique(DictClass(ind_),'stable')); 
       cntx1 = cntx1 + 1;
    end
    if(ind_s == 2)
       ind_ = ind_r2;
       s{i} = find(DictData2(i) == unique(DictClass2(ind_),'stable'));
       cntx2 = cntx2 + 1;
    end
    if(ind_s == 3)
       ind_ = ind_r3;
       s{i} = find(DictData3(i) == unique(DictClass3(ind_),'stable')); 
       cntx3 = cntx3 + 1;
    end
    if(ind_s == 4)
       ind_ = ind_r4;
       s{i} = find(DictData4(i) == unique(DictClass4(ind_),'stable'));
       cntx4 = cntx4 + 1;
    end

end
toc

rankPP = zeros(1,size(sys1,1));
z = zeros(1,size(sys1,1));
for ii=1:size(sys1,1)
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
axis([1 min(30,length(cmc)) min(cmc) max(cmc(1:min(30,length(cmc))))])
title('meta-recognition')
end