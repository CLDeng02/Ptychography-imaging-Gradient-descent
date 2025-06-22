%--------------------------------------------------------------------------
% Author: CL.Deng
% Email:  cldeng881@gmail.com
% ��ϸ�Ƶ����ע΢�Ź��ں� @���ӿ���
%--------------------------------------------------------------------------
%%
%�ݶ��½�ʵ������ָ�
clc
clear
close all
addpath(genpath('./imgs'))
addpath(genpath('./function'))
%Ŀ��ͼ������
I2=im2double(imread('peppers.bmp','bmp'));
I2=I2./max(I2(:));
[r,c]=size(I2);
wavelen=532e-9;%����m
dist=0.05;%�������m
pixsize=4e-6;%���سߴ�m
%imshow(I2)
apph=rand(r,c);%��ʼ���
beta=0.2;%ѧϰ��

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
A=Propagate(apph,dist,pixsize,wavelen);%��������ʱѡ�����������������
ab=A.*conj(A);
ab=ab./max(ab(:));
dA=ab-I2;
dapph=Propagate(dA.*A.*2,-dist,pixsize,wavelen);%��������ʱѡ������ݶȻش�����
%dapph=(ifft2(dA.*A.*2));
apph=apph-beta*dapph;%�����ݶ��½�
mse=sum(dA(:).^2)./(r*c);%�������

subplot(2,2,1)
imshow(I2,[])
title('ԭͼЧ��')
subplot(2,2,2)
imshow(abs(A).^2,[])
title('����Ч��')
subplot(2,2,3)
imshow(abs(apph),[])
title('ÿ�ε����ָ������')
subplot(2,2,4)
plot(j,mse,'b.')
title(['MSE=',num2str(mse)])
xlabel('iteration')
ylabel('MSE')
hold on
set(gcf,'color','w')
drawnow
end
