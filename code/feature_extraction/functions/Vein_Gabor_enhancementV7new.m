function [I, Energy_Map,  Scale_Map, Orient_Map, p_1]=Vein_Gabor_enhancementV7new(I, scale)

%I=im2double(imread('0002_13_2_IR.jpg'));
%%revised on june 29
% ang   : rotation angle
% d     : bandwidth
% w     : wavelength
% N     : Filter size
% a     : scale
I = im2double(I);
No_of_Orientation=16;%8 % in wrist paper 16 oreientations
No_of_Scale = length(scale);
a=scale;
[Gr Gi]=Gabor(0, 1.5, 1, 200, a(No_of_Scale));%1.5
p=Energy_check(Gr);
p_1=p+1;

Gabor_Matrix_Gr=zeros( 2*p+1, 2*p+1, No_of_Orientation, No_of_Scale);

ER=[0 0 0];

for s=1:No_of_Scale
    ang_count=0;
    for ang=0:180/No_of_Orientation:179
        ang_count=ang_count+1;
        [Gr Gi]=Gabor(ang, 1.5, 1, p, a(s)); %1.5
        Gabor_Matrix_Gr( :, :, ang_count, s )=Gr;
    end
    R=Energy_check(squeeze(Gabor_Matrix_Gr( :, :, 1, s )));
    ER(s)=R;
end

Energy_Map=zeros(size(I));
Scale_Map=ones(size(I));
Orient_Map=ones(size(I));

E=zeros(size(I,1), size(I,2), No_of_Orientation, No_of_Scale);
Image_Power=zeros(size(I,1), size(I,2), No_of_Scale);
I2=I.*I;

Gabor_fft_Matrix_Gr=zeros( size(I,1), size(I,2), No_of_Orientation, No_of_Scale );

I_fft = fft2(I);
for s=1:No_of_Scale
    for ang=1:No_of_Orientation
        pad = floor([(size(I,1)-(2*p+1))/2,(size(I,2)-(2*p+1))/2]);
        Gabor_fft_Matrix_Gr( : , :, ang, s ) = fft2(padarray(squeeze(Gabor_Matrix_Gr( : , :, ang, s )),pad),size(I,1),size(I,2));
    end
end
        
        
for s=1:No_of_Scale
    Image_Power(:,:,s)=filter2(ones(ER(s)) , I2, 'same').^0.5+0.1;
    for ang=1:No_of_Orientation
       E( : , :, ang, s )=fftshift(ifft2(-squeeze(Gabor_fft_Matrix_Gr( : , :, ang, s )).*I_fft))./squeeze(Image_Power(:,:,s)); 
    end
end

% Energy_Map=squeeze(E(:,:,1,1));


EngAng = zeros(size(I,1),size(I,2),No_of_Scale);
AngIdx = zeros(size(I,1),size(I,2),No_of_Scale);
for s=1:No_of_Scale
    [EngAng(:,:,s),AngIdx(:,:,s)] = max(E(:,:,:,s),[],3);%%%max min
end
[Energy_Map, Scale_Map] = max(EngAng,[],3);%%%max min
for x = 1:size(Energy_Map,1)
    for y = 1:size(Energy_Map,2)
        Orient_Map(x,y) = AngIdx(x,y,Scale_Map(x,y));
    end
end


% for x=1:size(I,1)
%     for y = 1:size(I,2)
%         for s=1:No_of_Scale
%             for ang=1:No_of_Orientation
%                 if (E(x,y,ang,s)>Energy_Map(x,y)&& E(x,y,ang,s)>0 )%&& R(x,y,ang,s)>0 && L(x,y,ang,s)>0) % && abs(R(s, ang, x,y)-L(s, ang, x,y))/E(s, ang, x,y)<0.5)
%                     Energy_Map(x,y)=E(x,y,ang,s);
%                     Scale_Map(x,y)=s;
%                     Orient_Map(x,y)=ang;
%                 end
%             end
% 
%         end
%     end  
% end
% Energy_Map=Energy_Map.*Scale_Map;

function R=Energy_check(G)

Total_energy=sum(sum(G.*G))^0.5;

S=(size(G,1)-1) /2;
cx=(size(G,1)-1)/2;
cy=(size(G,1)-1)/2;
R=S;
for x=1:S-1
   Energy=sum(sum(G(cx-x:cx+x, cy-x:cy+x).*G(cx-x:cx+x, cy-x:cy+x)))^0.5;
   Energy=Energy/Total_energy*100;
   if (Energy>99.9)
       R=x;
       break;
   end 
end
%%%Gabor(ang, 1.5, 1, p, a(s));
function [Gr Gi]=Gabor(ang, d, w, N, a)
% ang   : rotation angle
% d     : bandwidth
% w     : wavelength
% N     : Filter size
% a     : scale
k=(2*log(2))^0.5*((2^d+1)/(2^d-1));
Gr=zeros(2*N+1);
Gi=zeros(2*N+1);
ang_d=ang*pi/180;
COS=cos(ang_d);
SIN=sin(ang_d);
const=w/((2*pi)^0.5*k);

for x=-N:N
    for y=-N:N
        x_1=x*COS+y*SIN;
        y_1=-x*SIN+y*COS;
        x_1=x_1/a;
        y_1=y_1/a;
        temp=1/const*exp(-w*w/(8*k*k)*(4*x_1^2+y_1^2)); %%%?*x_1 ?越大越狭长 %%4  8
         Gr(x+N+1, y+N+1)=a^-1*temp*(cos(w*x_1)-exp(-k*k/2));
        Gi(x+N+1, y+N+1)=a^-1*temp*sin(w*x_1);
    end
end

