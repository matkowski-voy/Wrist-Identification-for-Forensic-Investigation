%% creates feature vectors 4 specific labels
%% labels wich are at least cover in minCoverArea param
%% by binaryCropMask
function [vec, s] = maskCreateFeatureVector3(s, rgb, rgbNorm, lab,...
    hsv, ycbcr, yiq, binaryCropMask, rowN, colN,extractFeatures)

minCoverArea = 0;
vec = [];
%% create 4-D multi color space matrix
colorSpaceMatrix(1,:,:,:) = rgb;
colorSpaceMatrix(2,:,:,:) = rgbNorm;
colorSpaceMatrix(3,:,:,:) = lab;
colorSpaceMatrix(4,:,:,:) = hsv;
colorSpaceMatrix(5,:,:,:) = ycbcr;
colorSpaceMatrix(6,:,:,:) = yiq;

rows = size(rgb,1); % image rows size
cols = size(rgb,2); % image columns size
row_ind = 0; % row index for samples/observations
% tic

       [labNorm, imgNorm, imgGx, imgGy, laplacian, lapX, lapY ...
    ] = maskAdd2DFeatures(rgb);
    Matrix2(1,:,:) = labNorm;
    Matrix2(2,:,:) = imgNorm;
    Matrix2(3,:,:) = imgGx;
    Matrix2(4,:,:) = imgGy;
    Matrix2(5,:,:) = laplacian;
    Matrix2(6,:,:) = lapX;
    Matrix2(7,:,:) = lapY;

for i=1:numel(s) % for all labels
%     tic
    if(s(i).Area > 0 && ...
           (mean(binaryCropMask(s(i).PixelIdxList)) > minCoverArea)) % if pos or neg
       if(extractFeatures == true)
       row_ind = row_ind + 1;
       k = 1;
%% set centroid as a feature
       vec(row_ind,k) = s(i).Centroid(1);
       k = k + 1;
       vec(row_ind,k) = s(i).Centroid(2);
       k = k + 1;
%% FOR 4 SECTION 1 and SECTION 2       
       for cs_ind=1:size(colorSpaceMatrix,1) % for color spaces
           for ch_ind=1:3 % for channels
               ch = colorSpaceMatrix(cs_ind,:,:,ch_ind);
               C = reshape(ch,rows,cols,1); % channel 2 process

%% SECTION 1 - SUPERPIXEL STAT FEATURES
               %% MEAN
               vec(row_ind,k) = mean(C(s(i).PixelIdxList));
               k = k + 1;
               %% STD
               vec(row_ind,k) = std(C(s(i).PixelIdxList));
               k = k + 1;
           end % end for channels        
       end % end for color spaces

%% SECTION 3 - NEIGHBOURS WITH DIRECTION INCLUDED UP DWON LEFT RIGHT       
       neighbour_cnt = 0;
       up_cnt = 1;
       down_cnt = 1;
       left_cnt = 1;
       right_cnt = 1;
       neighbourTab = zeros([],4);
       
       %% count Neighbour Array Dictionary
       for m=1:length(colN)
              if(colN(m) == i) % if this is neighbour
                neighborLabel = rowN(m);
                neighbour_cnt = neighbour_cnt +  1; 
                slope = (s(neighborLabel).Centroid(2) - s(i).Centroid(2))/...
                      (s(neighborLabel).Centroid(1) - s(i).Centroid(1));
                deg = atan(slope); % angle in radians
                deg = sqrt(deg*deg);
                if((deg > 0.785) && (s(neighborLabel).Centroid(2) ...
                        <= s(i).Centroid(2))) %up
                      neighbourTab(up_cnt,1) = neighborLabel;
                      up_cnt = up_cnt + 1;
                end
                if((deg > 0.785) && (s(neighborLabel).Centroid(2) ...
                        >= s(i).Centroid(2))) %down
                      neighbourTab(down_cnt,2) = neighborLabel;
                      down_cnt = down_cnt + 1;
                end
                if((deg <= 0.785) && s(neighborLabel).Centroid(1) ...
                        <= s(i).Centroid(1))%left
                      neighbourTab(left_cnt,3) = neighborLabel;
                      left_cnt = left_cnt + 1;
                end
                if((deg <= 0.785) && s(neighborLabel).Centroid(1) ...
                        >= s(i).Centroid(1)) %right
                      neighbourTab(right_cnt,4) = neighborLabel;
                      right_cnt = right_cnt + 1;
                end
              end
       end
%       maskBuildNeighbourTab
neighbourTab2 = neighbourTab;
    
    for d=1:4
        n = size(neighbourTab2,1);
        swapped = true;
        j_ = 0;
        param1 = 0;
        param2 = 0;
        while(swapped)
            swapped = false;
            j_ = j_ + 1;
            for ni=1:n-j_
                if(neighbourTab2(ni,d) == 0)
                  param1 = 0;             
                else
                    param1 = s(neighbourTab2(ni,d)).Area;
                end
                if(neighbourTab2(ni+1,d) == 0)
                   param2 = 0;
                else
                    param2 = s(neighbourTab2(ni+1,d)).Area;
                end
                if(param1 <  param2)
                   tmp = neighbourTab2(ni,d); 
                   neighbourTab2(ni,d) = neighbourTab2(ni+1,d);
                   neighbourTab2(ni+1,d) = tmp;
                   swapped = true;
                end
            end
        end
        
        if(size(neighbourTab2,1) > 2)
            tmp =  neighbourTab2(1:2,:); %% could do better code
            neighbourTab2 = [];
            neighbourTab2 = tmp;
        end
        
        cnt = 0;
        indDict = 0;
        for ni=1:size(neighbourTab2,1)
            if(neighbourTab2(ni,d) == 0)
                cnt = cnt + 1;
                indDict = ni;
            end
        end
        if(cnt == size(neighbourTab2,1))
           neighbourTab2(:,d) = i; 
        end
        if(cnt < size(neighbourTab2,1) && cnt > 0)
            neighbourTab2(indDict,d) = sum(neighbourTab2(:,d));
        end
        if(size(neighbourTab,1) == 1)
            neighbourTab2(2,d) = neighbourTab2(1,d);
        end

    end

       %% process Neighbour Array Dictionary and put features into vector
       for cs_ind=1:size(colorSpaceMatrix,1)% for color spaces   
               for d=1:4 % for up down left right directions
                  for ch_ind=1:3 % for channels
                    meanCD_tmp = 0;
                    stdCD_tmp = 0;
                    sumArea_tmp = 0;
                    ch = colorSpaceMatrix(cs_ind,:,:,ch_ind);
                    C = reshape(ch,rows,cols,1); % channel 2 process
                        for nc=1:size(neighbourTab2,1)
                          vec(row_ind,k) = mean(C(s(neighbourTab2(nc,d)).PixelIdxList));
                          k = k + 1;
                          vec(row_ind,k) = std(C(s(neighbourTab2(nc,d)).PixelIdxList));
                          k = k + 1;

                        end

                  end % end for channels
               end % end for directions
       end % end for color spaces
       
%% SECTION 4 - extrac additional features  
% tic
%        [labNorm, imgNorm, imgGx, imgGy, laplacian, lapX, lapY ...
%     ] = maskAdd2DFeatures(rgb);
%     Matrix2(1,:,:) = labNorm;
%     Matrix2(2,:,:) = imgNorm;
%     Matrix2(3,:,:) = imgGx;
%     Matrix2(4,:,:) = imgGy;
%     Matrix2(5,:,:) = laplacian;
%     Matrix2(6,:,:) = lapX;
%     Matrix2(7,:,:) = lapY;
%     toc
%     pause
%     fprintf('hmmm1\n');
    
    %% 
    for m=1:size(Matrix2,1)
        M = Matrix2(m,:,:);
        M = reshape(M,rows,cols,1);
        vec(row_ind,k) = mean(M(s(i).PixelIdxList));
        k = k + 1;
        vec(row_ind,k) = std(M(s(i).PixelIdxList));
        k = k + 1;
        for d=1:4
            for nc=1:size(neighbourTab2,1)
               vec(row_ind,k) = mean(M(s(neighbourTab2(nc,d)).PixelIdxList));
               k = k + 1;
               vec(row_ind,k) = std(M(s(neighbourTab2(nc,d)).PixelIdxList));
               k = k + 1;
            end
        end
        
    end
    
  end
    
    
           
      s(i).isOutSample = false;    
    end %end for if label is target to extract
%     toc
%     pause

end %end for all labels
% toc
end %end of fucntion