%--------------------------------------------------------------------------
% Author: CL.Deng
% Email:  cldeng881@gmail.com
% 详细推导请关注微信公众号 @智子科普
%--------------------------------------------------------------------------
%%
%梯度下降实现振幅恢复
clc
clear
close all
addpath(genpath('./imgs'))
addpath(genpath('./function'))
%目标图像衍射
I2=im2double(imread('peppers.bmp','bmp'));
I2=I2./max(I2(:));
[r,c]=size(I2);
wavelen=532e-9;%波长m
dist=0.05;%衍射距离m
pixsize=4e-6;%像素尺寸m
%imshow(I2)
apph=rand(r,c);%初始振幅
beta=0.2;%学习率

% x1=-256:255;
% [x11,y11]=meshgrid(x1,x1);
% circle=zeros(512,512);
% circle(abs(x11+1i*y11)<128)=1;
% I2=abs(propagate(circle,dist,pixsize,wavelen)).^2;
% I2=I2./max(I2(:));
% figure(1)
% imshow(circle,[])
% figure(2)
% imshow(I2,[])
%%
for j=1:30
%A=fft2(apph);
A=Propagate(apph,dist,pixsize,wavelen);%仿真衍射时选择这个正向衍射算子
ab=A.*conj(A);
ab=ab./max(ab(:));
dA=ab-I2;
dapph=Propagate(dA.*A.*2,-dist,pixsize,wavelen);%仿真衍射时选择这个梯度回传算子
%dapph=(ifft2(dA.*A.*2));
apph=apph-beta*dapph;%复数梯度下降
mse=sum(dA(:).^2)./(r*c);%均方误差

subplot(2,2,1)
imshow(I2,[])
title('原图效果')
subplot(2,2,2)
imshow(abs(A).^2,[])
title('衍射效果')
subplot(2,2,3)
imshow(abs(apph),[])
title('每次迭代恢复的振幅')
subplot(2,2,4)
plot(j,mse,'b.')
title(['MSE=',num2str(mse)])
xlabel('iteration')
ylabel('MSE')
hold on
set(gcf,'color','w')
drawnow
end
