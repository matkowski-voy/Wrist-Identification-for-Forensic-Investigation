function [fVector] = maskExtract2(C1,C2,C3,Mask,settings,gray)


mapping1 = settings.mapping1;
mapping2 = settings.mapping2;
radius1 = settings.radius1;
radius2 = settings.radius2;
neighb = settings.neighb;
grid = settings.grid;
scanVisLBP = settings.scanVisLBP;
gray2 = (0.2989 * C1) + (0.5870 * C2) + (0.1140 * C3); 
% 

%% extract LBP features
    mask = imerode(Mask,strel('disk',3));  
    img = C1;
    F1C1=lbp(padarray(img,[radius1*2 radius1*2]),radius1,neighb,mapping1,'image');
    F1C1 = F1C1(radius1+1:end-radius1,radius1+1:end-radius1);
    F1C1 = F1C1 + 1;
    F1C1 = maskimage(F1C1,~mask);

    F2C1=lbp(padarray(img,[radius2*2 radius2*2]),radius2,neighb,mapping2,'image');
    F2C1 = F2C1(radius2+1:end-radius2,radius2+1:end-radius2);
    F2C1 = F2C1 + 1;
    F2C1 = maskimage(F2C1,~mask);
  
    img = C2;
    F1C2=lbp(padarray(img,[radius1*2 radius1*2]),radius1,neighb,mapping1,'image');
    F1C2 = F1C2(radius1+1:end-radius1,radius1+1:end-radius1);
    F1C2 = F1C2 + 1;
    F1C2 = maskimage(F1C2,~mask);  
     
    F2C2=lbp(padarray(img,[radius2*2 radius2*2]),radius2,neighb,mapping2,'image');
    F2C2 = F2C2(radius2+1:end-radius2,radius2+1:end-radius2);
    F2C2 = F2C2 + 1;
    F2C2 = maskimage(F2C2,~mask);
   
    img = C3;
    F1C3=lbp(padarray(img,[radius1*2 radius1*2]),radius1,neighb,mapping1,'image');
    F1C3 = F1C3(radius1+1:end-radius1,radius1+1:end-radius1);
    F1C3 = F1C3 + 1;
    F1C3 = maskimage(F1C3,~mask);

    F2C3=lbp(padarray(img,[radius2*2 radius2*2]),radius2,neighb,mapping2,'image');
    F2C3 = F2C3(radius2+1:end-radius2,radius2+1:end-radius2);
    F2C3 = F2C3 + 1;
    F2C3 = maskimage(F2C3,~mask);
    

        %% extract for C1 channel
        binNumLBP = 59;
        [histMatrixLBP] = maskExtractLBP(F1C1,grid{1},10,scanVisLBP);
        f1 = reshape(histMatrixLBP',1,size(histMatrixLBP,1)*size(histMatrixLBP,2));
         
        [histMatrixLBP] = maskExtractLBP(F1C1,grid{2},10,scanVisLBP);
        f2 = reshape(histMatrixLBP',1,size(histMatrixLBP,1)*size(histMatrixLBP,2));
          
        [histMatrixLBP] = maskExtractLBP(F2C1,grid{3},binNumLBP,scanVisLBP);
        f3 = reshape(histMatrixLBP',1,size(histMatrixLBP,1)*size(histMatrixLBP,2));

        [histMatrixLBP] = maskExtractLBP(F2C1,grid{4},binNumLBP,scanVisLBP);
        f4 = reshape(histMatrixLBP',1,size(histMatrixLBP,1)*size(histMatrixLBP,2));
        
        [histMatrixLBP] = maskExtractLBP(F2C1,grid{5},binNumLBP,scanVisLBP);
        f5 = reshape(histMatrixLBP',1,size(histMatrixLBP,1)*size(histMatrixLBP,2));
        
        [histMatrixLBP5] = maskExtractLBP(F2C1,grid{6},binNumLBP,scanVisLBP);
        f6 = reshape(histMatrixLBP5',1,size(histMatrixLBP5,1)*size(histMatrixLBP5,2));
        
        [histMatrixLBP] = maskExtractLBP(F2C1,grid{7},binNumLBP,scanVisLBP);
        f7 = reshape(histMatrixLBP',1,size(histMatrixLBP,1)*size(histMatrixLBP,2));
         
        
        %% extract for C2 channel
        [histMatrixLBP] = maskExtractLBP(F1C2,grid{1},10,scanVisLBP);
        f8 = reshape(histMatrixLBP',1,size(histMatrixLBP,1)*size(histMatrixLBP,2));
         
        [histMatrixLBP] = maskExtractLBP(F1C2,grid{2},10,scanVisLBP);
        f9 = reshape(histMatrixLBP',1,size(histMatrixLBP,1)*size(histMatrixLBP,2));

        [histMatrixLBP] = maskExtractLBP(F2C2,grid{3},binNumLBP,scanVisLBP);
        f10 = reshape(histMatrixLBP',1,size(histMatrixLBP,1)*size(histMatrixLBP,2));
        
        [histMatrixLBP] = maskExtractLBP(F2C2,grid{4},binNumLBP,scanVisLBP);
        f11 = reshape(histMatrixLBP',1,size(histMatrixLBP,1)*size(histMatrixLBP,2));
        
        [histMatrixLBP] = maskExtractLBP(F2C2,grid{5},binNumLBP,scanVisLBP);
        f12 = reshape(histMatrixLBP',1,size(histMatrixLBP,1)*size(histMatrixLBP,2));
        
        [histMatrixLBP] = maskExtractLBP(F2C2,grid{6},binNumLBP,scanVisLBP);
        f13 = reshape(histMatrixLBP',1,size(histMatrixLBP,1)*size(histMatrixLBP,2));
        
        [histMatrixLBP] = maskExtractLBP(F2C2,grid{7},binNumLBP,scanVisLBP);
        f14 = reshape(histMatrixLBP',1,size(histMatrixLBP,1)*size(histMatrixLBP,2));
        
        
        %% extract for C3 channel
        [histMatrixLBP] = maskExtractLBP(F1C3,grid{1},10,scanVisLBP);
        f15 = reshape(histMatrixLBP',1,size(histMatrixLBP,1)*size(histMatrixLBP,2));
        
        [histMatrixLBP] = maskExtractLBP(F1C3,grid{2},10,scanVisLBP);
        f16 = reshape(histMatrixLBP',1,size(histMatrixLBP,1)*size(histMatrixLBP,2));
        
        [histMatrixLBP] = maskExtractLBP(F2C3,grid{3},binNumLBP,scanVisLBP);
        f17 = reshape(histMatrixLBP',1,size(histMatrixLBP,1)*size(histMatrixLBP,2));
        
        [histMatrixLBP] = maskExtractLBP(F2C3,grid{4},binNumLBP,scanVisLBP);
        f18 = reshape(histMatrixLBP',1,size(histMatrixLBP,1)*size(histMatrixLBP,2));
        
        [histMatrixLBP] = maskExtractLBP(F2C3,grid{5},binNumLBP,scanVisLBP);
        f19 = reshape(histMatrixLBP',1,size(histMatrixLBP,1)*size(histMatrixLBP,2));
        
        [histMatrixLBP] = maskExtractLBP(F2C3,grid{6},binNumLBP,scanVisLBP);
        f20 = reshape(histMatrixLBP',1,size(histMatrixLBP,1)*size(histMatrixLBP,2));
        
        [histMatrixLBP] = maskExtractLBP(F2C3,grid{7},binNumLBP,scanVisLBP);
        f21 = reshape(histMatrixLBP',1,size(histMatrixLBP,1)*size(histMatrixLBP,2));
        
% Gabor features
    s = [.2 .5 .7 .9];
    rp = 1;
    ImgGabor = padarray(gray2,[rp rp]); 
    maskGabor = padarray(Mask,[rp rp]);
    [~,~,~,Orient_Map ,~]=Vein_Gabor_enhancementV7new(ImgGabor, s);

    Orient_Map = Orient_Map(rp+1:end-rp,rp+1:end-rp);
    maskGabor = imerode(maskGabor,strel('disk',8));
    maskGabor = maskGabor(rp+1:end-rp,rp+1:end-rp);
    Orient_Map = Orient_Map + 1;
    Orient_Map = maskimage(Orient_Map,~maskGabor);

    [histMatrixGabor] = maskExtractGabor(Orient_Map,grid{1},false);
    f22 = reshape(histMatrixGabor',1,size(histMatrixGabor,1)*size(histMatrixGabor,2));
    
    [histMatrixGabor] = maskExtractGabor(Orient_Map,grid{2},false);
    f23 = reshape(histMatrixGabor',1,size(histMatrixGabor,1)*size(histMatrixGabor,2));
    
    [histMatrixGabor] = maskExtractGabor(Orient_Map,grid{3},false);
    f24 = reshape(histMatrixGabor',1,size(histMatrixGabor,1)*size(histMatrixGabor,2));
    
    [histMatrixGabor] = maskExtractGabor(Orient_Map,grid{4},false);
    f25 = reshape(histMatrixGabor',1,size(histMatrixGabor,1)*size(histMatrixGabor,2));
    
    [histMatrixGabor] = maskExtractGabor(Orient_Map,grid{5},false);
    f26 = reshape(histMatrixGabor',1,size(histMatrixGabor,1)*size(histMatrixGabor,2));
    
    [histMatrixGabor] = maskExtractGabor(Orient_Map,grid{6},false);
    f27 = reshape(histMatrixGabor',1,size(histMatrixGabor,1)*size(histMatrixGabor,2));
    
    [histMatrixGabor] = maskExtractGabor(Orient_Map,grid{7},false);
    f28 = reshape(histMatrixGabor',1,size(histMatrixGabor,1)*size(histMatrixGabor,2));
    

% DSIFT features
[~,f29] = vl_dsift(single(gray),'step',16,'size',16);
f29 = double(f29);
f29 = reshape(f29,128*size(f29,2),1)';

fVector = [f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 ...
    f11 f12 f13 f14 f15 f16 f17 f18 f19 f20 ...
    f21 f22 f23 f24 f25 f26 f27 f28 f29];
 
end