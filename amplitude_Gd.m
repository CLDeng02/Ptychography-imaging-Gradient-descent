%--------------------------------------------------------------------------
% Author: CL.Deng
% Email:  cldeng881@gmail.com 
% For detailed mathematical derivations, please follow our WeChat official account  @智子科普
%--------------------------------------------------------------------------
%%
clc
clear
close all
addpath(genpath('./imgs'))
addpath(genpath('./function'))

I2=im2double(imread('peppers.bmp','bmp'));%diffraction target
I2=I2./max(I2(:));
[r,c]=size(I2);
wavelen=532e-9;%wavelength(m)
dist=0.05;%diffraction distance(m)
pixsize=4e-6;%Pixel size (m)
%imshow(I2)
apph=rand(r,c);%initial amplitude 
beta=0.2;%learning rate

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
A=Propagate(apph,dist,pixsize,wavelen);%forward diffraction operator
ab=A.*conj(A);
ab=ab./max(ab(:));
dA=ab-I2;
dapph=Propagate(dA.*A.*2,-dist,pixsize,wavelen);%backpropagation operator
%dapph=(ifft2(dA.*A.*2));
apph=apph-beta*dapph;%complex gradient descent
mse=sum(dA(:).^2)./(r*c);%mean squared error

subplot(2,2,1)
imshow(I2,[])
title('target image')
subplot(2,2,2)
imshow(abs(A).^2,[])
title('diffraction image')
subplot(2,2,3)
imshow(abs(apph),[])
title('reconstructed amplitude')
subplot(2,2,4)
plot(j,mse,'b.')
title(['MSE=',num2str(mse)])
xlabel('iteration')
ylabel('MSE')
hold on
set(gcf,'color','w')
drawnow
end
