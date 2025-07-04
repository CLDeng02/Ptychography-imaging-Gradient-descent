%--------------------------------------------------------------------------
% Author: CL.Deng
% Email:  cldeng881@gmail.com
%--------------------------------------------------------------------------
%%
clear;
close all;
clc;
addpath(genpath('./functions'));
addpath(genpath('./imgs'));
im_ampl=im2double(imread('lake.bmp'));
im_phase=im2double(imread('FAI.bmp'));
[M,N]=size(im_ampl);
domain=zeros(M,N);
amp = imresize(im_ampl,[512,512]);
amp(amp<0)=0;amp(amp>1)=1;
pha = imresize(im_phase,[512,512]);
pha(pha<0)=0;pha(pha>1)=1;


image = amp.*exp(1j.*pha);
figure;imshow(abs(image),[]);
figure;imshow(angle(image),[]);

%%
%Segment Diffraction Regions
k=0;r=256;c=256;
iter=1;
deta=10;%move step length
seg=7;%the number of segment
if mod(seg,2)==0
    segd=-seg/2:seg/2-1;
else
    segd=-(seg-1)/2:(seg-1)/2;
end
for i=segd
    for j=segd
        dy = i*deta;
        dx = j*deta;
        k=k+1;
        im_set(:,:,k)=image(M/2-r/2+dy:M/2+r/2-1+dy,N/2-c/2+dx:N/2+c/2-1+dx);
        domain(M/2-r/2+dy:M/2+r/2-1+dy,N/2-c/2+dx:N/2+c/2-1+dx)=ones(r,c);
        subplot(seg,seg,iter)
        imshow(real(im_set(:,:,k)),[]);
        iter=iter+1;
    end
end
%Construct an RGB image of the scanned domain
p1=im_ampl+domain;
p2=im_ampl-domain;
domainpic(:,:,1)=uint8(floor(255.*p2./max(p1(:))));
domainpic(:,:,2)=uint8(floor(255.*p1./max(p1(:))));
domainpic(:,:,3)=uint8(floor(255.*p2./max(p1(:))));
%%
%create hole mask
pixSize = 3*1e-6;
mask_x = linspace(-pixSize*r/2,pixSize*r/2,r);
[x1,y1] = meshgrid(mask_x);
cir_hole = zeros(r,r);
cir_hole(abs(x1 + 1i*y1) < 3*r.*pixSize./10) = 1;
a = cir_hole;
figure;imshow(a);

%create the illumination function for ptychography
lambda=5320*10^(-10); 
d=0.01;
U = Propagate(cir_hole,d,pixSize,lambda);
subplot(1,2,1)
imshow(abs(U),[]);title('amplitude')
subplot(1,2,2)
imshow(angle(U),[]);title('phase')

%%
%create the diffraction image set
Z=0.1;%m
iter=1;
for k=1:seg*seg
    exitE= U.*im_set(:,:,k);
    diff_set(:,:,k) = Propagate(exitE,Z,pixSize,lambda);
    subplot(seg,seg,iter)
    imshow(real(diff_set(:,:,k)),[]);
    iter=iter+1;
end


%%
%Gradient descent
Mpad = M;Npad = N;
P = U;
sample= ones(Mpad, Npad);
epoch=200;
% deta=20;
Z=0.1;
alpha=0.2;%Learning Rate

[sample_new,MSE]= Grad_ptych(diff_set,P,sample,epoch,deta,Z,pixSize,lambda,alpha,segd);
%%
%draw picture
subplot(2,2,1);imshow(abs(sample_new),[]),title('reconstructed amplitude');
subplot(2,2,2);imshow(angle(sample_new),[]),title('reconstructed phase');
subplot(2,2,3);imshow(domainpic),title('scan domain');
subplot(2,2,4);plot(1:epoch,MSE,'LineWidth',1.5),title('Error Descent Curve');xlabel('iteration');ylabel('MSE');
set(gcf,'color','w')


