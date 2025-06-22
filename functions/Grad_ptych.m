function [sample,MSE] = Grad_ptych(CCD,P,sample,epoch,deta,Z,pixSize,lambda,alpha,segd)
%CCD    diffraction image dataset
%P      light probe
%sample initial sample amplitude
%epoch  iteration
%deta   move step length
%Z      diffraction distance
G_u=ones(size(sample));
[yP,xP] = size(P);
r=yP;c=xP;
[M,N] = size(sample);
for i = 1:epoch
    k = 1;mse=zeros(r,c);
    for ii = segd
        for jj = segd
            dy=deta*ii;dx=deta*jj;
           
            sub_u=sample(M/2-r/2+dy:M/2+r/2-1+dy,N/2-c/2+dx:N/2+c/2-1+dx);
            exitwave = sub_u.*P; 
            U1 = Propagate(exitwave,Z,pixSize,lambda);%forward

            dU=(abs(U1)-abs(CCD(:,:,k))).*U1.*2;%error gradient in surface of CCD

            mse=mse+(abs(U1)-abs(CCD(:,:,k))).^2./(r*c);%mean squared error
        
            G_subu=Propagate(dU,-Z,pixSize,lambda).*conj(P);%backpropagation error gradient to sample surface
        
            G_u(M/2-r/2+dy:M/2+r/2-1+dy,N/2-c/2+dx:N/2+c/2-1+dx)...
            =G_u(M/2-r/2+dy:M/2+r/2-1+dy,N/2-c/2+dx:N/2+c/2-1+dx)-alpha*G_subu; %Gradient descent in complex domain

        k = k + 1;
           
        end
         sample=G_u;
    end
    MSE(i)=sum(mse(:))/(r*c*length(segd).^2);
    disp(['iteration:',num2str(i),'   error：',num2str(MSE(i))])
end

end
