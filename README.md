# Ptychography-imaging-Gradient-descent
Recovering the amplitude and phase information of a sample from ptychographic diffraction data using the gradient descent method.
- **amplitude_Gd ：** The file "amplitude_Gd" is designed to recover the amplitude distribution that can diffract into a target image using the gradient descent method when the target image is provided.
- **ptych_Gd ：** The file "ptych_Gd" is a complete simulation program that applies the gradient descent method to ptychography.

<div align = 'center'>
<img src = "https://github.com/CLDeng02/Ptychography-imaging-Gradient-descent/blob/main/resource/reconstructed%20image.png" width = "300" alt="" align = center />
</div><br>

## How does it work ?<br>
The diffractive optical system is strictly linear, so the propagation of the system can be expressd as following equation:
<br>

```math
\mathbf{A}=D\mathbf{x}
```
<br>

Here, $D(\cdot)$ denotes the propagation operator,and $\mathbf{x}$ is input vector. For an $N\times N$-size image, $\mathbf{x}$ can be regarded as a column vector of $N^2$ dimension composed of the values of all pixels in the input image. When the input image has only a single complex element $(x+yi)$.
<br>

```math
A=\alpha R 
\begin{bmatrix}
x \\
y \\
\end{bmatrix}
```
<br>

a is scaling factor, and $\mathbf{R}$ is unitary matrix. Since the optical intensity signal is received, an error loss function for the domain target distribution $\mathbf{C}$ can be constructed as follows using the $L^2$ -norm:
<br>

```math
Loss(x.y)=(A^\star A-C)^2=\big( 
\begin{bmatrix}
x & y
\end{bmatrix}
\alpha^2 R^T R 
\begin{bmatrix}
x \\
y
\end{bmatrix}
-C \big)^2=\big( \alpha^2 (x^2+y^2) -C \big)^2
```
<br>


