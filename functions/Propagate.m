function [w_o] = Propagate(w_i, dist, pixSize, wavlen)

% dimension of the wavefield
[ny,nx] = size(w_i);

% sampling in the frequency domain
kx = pi/pixSize*(-1:2/nx:1-2/nx);%³¤¶ÈÎªN1
ky = pi/pixSize*(-1:2/ny:1-2/ny);
[KX,KY] = meshgrid(kx,ky);

% wave number
k = 2*pi/wavlen;

% circular convoluion via ffts
inputFT = fftshift(fft2(w_i));
H = exp(1i*dist*sqrt(k^2-KX.^2-KY.^2));
w_o = ifft2(ifftshift(inputFT.*H));

end

