# Ptychography-imaging-Gradient-descent
Recovering the amplitude and phase information of a sample from ptychographic diffraction data using the gradient descent method.
- **amplitude_Gd ：** The file "amplitude_Gd" is designed to recover the amplitude distribution that can diffract into a target image using the gradient descent method when the target image is provided.
- **ptych_Gd ：** The file "ptych_Gd" is a complete simulation program that applies the gradient descent method to ptychography.

# How does it work ?
The diffractive optical system is strictly linear, so the propagation of the system can be expressd as fllowing equation://
$\mathbf{A}=D\mathbf{x}$//
Here, $D(\cdot)$ denotes the propagation operator,and $\mathbf{x}$ is input vector. For an $N\times N$-size image, $\mathbf{x}$ can be regarded as a column vector of $N^2$ dimension composed of the values of all pixels in the input image.

