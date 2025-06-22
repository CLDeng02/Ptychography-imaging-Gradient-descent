function [sample,MSE] = Grad_ptych(CCD,P,sample,epoch,deta,Z,pixSize,lambda,alpha)
%CCD    衍射采集到的数据（多维矩阵）
%P      探针矩阵
%sample 样品初始复振幅
%epoch  迭代次数
%deta   移动步长
%Z      衍射距离
G_u=ones(size(sample));
[yP,xP] = size(P);
r=yP;c=xP;
[M,N] = size(sample);
for i = 1:epoch
    k = 1;mse=zeros(r,c);
    for ii = -1:1
        for jj = -1:1
            dy=deta*ii;dx=deta*jj;
           
            sub_u=sample(M/2-r/2+dy:M/2+r/2-1+dy,N/2-c/2+dx:N/2+c/2-1+dx);
            exitwave = sub_u.*P; 
            U1 = Propagate(exitwave,Z,pixSize,lambda);%正向传播产生预测图

            dU=(abs(U1)-abs(CCD(:,:,k))).*U1.*2;%计算CCD面误差梯度

            mse=mse+(abs(U1)-abs(CCD(:,:,k))).^2./(r*c);%均方误差
        
            G_subu=Propagate(dU,-Z,pixSize,lambda).*conj(P);%反向传播误差梯度得到样品面的梯度
        
            G_u(M/2-r/2+dy:M/2+r/2-1+dy,N/2-c/2+dx:N/2+c/2-1+dx)...
            =G_u(M/2-r/2+dy:M/2+r/2-1+dy,N/2-c/2+dx:N/2+c/2-1+dx)-alpha*G_subu;%扩展到复数域的梯度下降

        k = k + 1;
           
        end
         sample=G_u;
    end
    MSE(i)=sum(mse(:))/(r*c*9);
    disp(['第',num2str(i),'次迭代误差：',num2str(MSE(i))])
end

end
