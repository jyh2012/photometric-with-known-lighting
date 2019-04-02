clear all;
clc;
close all;
%%
P = '.\images';%替换成文件夹路径
D = dir(fullfile(P,'*.pgm'));
C = cell(size(D));
for k = 1:numel(D)
    C{k,1} = imread(fullfile(P,D(k).name));
    if D(k).name(13)=='+'
         C{k,2} = str2double(D(k).name(14:16));
    else
        C{k,2} = -str2double(D(k).name(14:16));
    end
    if D(k).name(18)=='+'
        C{k,3} = str2double(D(k).name(19:20));
    else
        C{k,3} = -str2double(D(k).name(19:20));
    end
end
for idx=1:64
    C{idx,1}=C{idx,1}-C{65,1};
end

load('C.mat');
%%
Light=zeros(length(C)-1,3);
for idx=1:length(C)-1
    Light(idx,2) = -cos(C{idx,3}/180*pi) * cos(C{idx,2}/180*pi);
    Light(idx,1) = cos(C{idx,3}/180*pi) * sin(C{idx,2}/180*pi);
    Light(idx,3) = sin(C{idx,3}/180*pi);
end
%load('Light.mat');
%%
mask = zeros(480,640);
for i = 2:479
    for j =1:640
        if j>=200 && j<=500
            mask(i,j) = 1;
        else
            mask(i,j) = 0;
        end
    end
end

%load('mask.mat');
%%
% mask=C{1,1};
% mask1=0.9*im2uint8(ones(480,640));
% mask=imadd(mask,mask1);
% mask(1:390,1:200)=0;
% mask(1:390,480:640)=0;
% mask(391:480,1)=0;
% mask(391:480,640)=0;
% mask(480,1:640)=0;
% mask(1,1:640)=0;
% k1=find(mask<240);
% mask(k1)=0;
% clear k1;
%imshow(mask);
%%
I=cell(64,1);
for k =1:length(C)-1
    for i=1:480
        for j=1:640
          I{k}(i,j,1)=C{k,1}(i,j);
          I{k}(i,j,2)=C{k,1}(i,j);
          I{k}(i,j,3)=C{k,1}(i,j);
        end
    end
end
%load('I.mat');
%%
N = compute_surfNorm(I, Light, mask);
for i=1:480
    for j=1:640
        temp = N(i,j,2);
        N(i,j,2) = N(i,j,3);
        N(i,j,3) = temp;
    end
end
        
h = show_surfNorm(N, 4);
figure,
imshow(N);
imwrite(N,'surfNorm.png');
saveas(h,'surfNorm4.png');
Z = Integration_FC(N, mask,4,'F',0,0);
figure,
showsurf(Z,1:640,1:480);