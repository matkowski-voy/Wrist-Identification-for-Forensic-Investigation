%% Builds graph from an image I
% conn defines conectivity (4 or 8)
% diagParamD defines the distance for diagonal connections
% if diagParamD = 2 then diagonal path = sqrt(2)
% powerParam defines power impact
function G = maskBuildGraph(I,mask,conn, diagParamD,powerParam)
fprintf(' -: building graph\n');
if((conn ~= 8) && (conn ~=4))
    fprintf('warning: graph connectivity error\n');
    fprintf('auto setting default value: conn = 4\n');
    conn = 4;
end

delta = 0.1; % some small value to avoid zeros

% build adjency matrix H for entire image I
mat = (1:size(I,1)*size(I,2));
mat = reshape(mat,size(I,1),size(I,2))';
[r,c] = size(mat);                        
diag1 = repmat([ones(c-1,1); 0],r,1);                                           
diag1 = diag1(1:end-1);             

if(conn == 8)
    diag2 = [0; diag1(1:(c*(r-1)))];    
    diag2 = diag2.*sqrt(diagParamD);    %% sqrt @&%&^%*%^#&%%@$&%@$%*^%*                                     
    diag3 = ones(c*(r-1),1);                                                         
    diag4 = diag2(2:end-1);             
    diag4 = diag4.*sqrt(diagParamD);     %% sqrt @&%&^%*%^#&%%@$&%@$%*^%*                                         
    H = diag(diag1,1)+diag(diag2,c-1)+diag(diag3,c)+diag(diag4,c+1);
end

if(conn == 4)
    diag2 = ones(c*(r-1),1);                                                       
    H = diag(diag1,1)+diag(diag2,c);
end
H = H+H.';

% set connections only between foreground pixels defined in mask
w = reshape(I,size(I,1)*size(I,2),1);
bw = reshape(mask,size(I,1)*size(I,2),1);
w = ((w + abs(min(w)) + delta).^powerParam).*bw; % move to positives
 % .*bw - this is to avoid setting zeros to foreground pixels with the min(weight) 
H = bsxfun(@times,H,w);

% I2  = I + abs(min(min(I))) + delta;
% figure; imshow(I2);
% pause
 
G = sparse(bsxfun(@times,H,w));

end