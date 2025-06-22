%--------------------------------------------------------------------------
% Author: CL.Deng
% Email:  cldeng881@gmail.com
% 详细推导请关注微信公众号 @智子科普
%--------------------------------------------------------------------------
%%
clear;
close all;
clc;
addpath(genpath('./functions'));%添加自定义函数文件夹
addpath(genpath('./imgs'));%添加图片文件夹路径
im_ampl=im2double(imread('lake.bmp'));
im_phase=im2double(imread('FAI.bmp'));
[M,N]=size(im_ampl);

amp = imresize(im_ampl,[512,512]);
amp(amp<0)=0;amp(amp>1)=1;
pha = imresize(im_phase,[512,512]);
pha(pha<0)=0;pha(pha>1)=1;


image = amp.*exp(1j.*pha);
figure;imshow(abs(image),[]);
figure;imshow(angle(image),[]);

%%
%分割储存图片
k=0;r=256;c=256;
iter=1;
deta=10;%移动步长
for i=-1:1
    for j=-1:1
        dy = i*deta;
        dx = j*deta;
        k=k+1;
        im_set(:,:,k)=image(M/2-r/2+dy:M/2+r/2-1+dy,N/2-c/2+dx:N/2+c/2-1+dx);
        subplot(3,3,iter)
        imshow(real(im_set(:,:,k)),[]);
        iter=iter+1;
    end
end


%%
%生成小孔
pixSize = 3*1e-6;
mask_x = linspace(-pixSize*r/2,pixSize*r/2,r);
[x1,y1] = meshgrid(mask_x);
cir_hole = zeros(r,r);
cir_hole(abs(x1 + 1i*y1) < r.*pixSize./5) = 1;
a = cir_hole;
figure;imshow(a);
%产生探针
lambda=5320*10^(-10); 
d=0.01;
U = Propagate(cir_hole,d,pixSize,lambda);
subplot(1,2,1)
imshow(abs(U),[]);title('amplitude')
subplot(1,2,2)
imshow(angle(U),[]);title('phase')

%%
%生成衍射数据集
Z=0.1;%m
iter=1;
for k=1:9
    exitE= U.*im_set(:,:,k);
    diff_set(:,:,k) = Propagate(exitE,Z,pixSize,lambda);
    subplot(3,3,iter)
    imshow(real(diff_set(:,:,k)),[]);
    iter=iter+1;
end


%%
%梯度下降恢复
Mpad = M+20;Npad = N+20;
P = U;
sample= ones(Mpad, Npad);
epoch=200;
% deta=20;
Z=0.1;
alpha=0.2;%学习率

[sample_new,MSE]= Grad_ptych(diff_set,P,sample,epoch,deta,Z,pixSize,lambda,alpha);
%%
%绘图
subplot(2,2,1);imshow(abs(sample_new),[]),title('恢复的振幅');
subplot(2,2,2);imshow(angle(sample_new),[]),title('恢复的相位');
subplot(2,2,3);plot(1:epoch,MSE,'LineWidth',1.5),title('误差下降曲线');xlabel('iteration');ylabel('MSE');
set(gcf,'color','w')


