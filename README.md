# Ptychography-imaging-Gradient-descent
Recovering the amplitude and phase information of a sample from ptychographic diffraction data using the gradient descent method.
- **amplitude_Gd ：** The file "amplitude_Gd" is designed to recover the amplitude distribution that can diffract into a target image using the gradient descent method when the target image is provided.
- **ptych_Gd ：** The file "ptych_Gd" is a complete simulation program that applies the gradient descent method to ptychography.

<div align = 'center'>
<img src = "https://github.com/CLDeng02/Ptychography-imaging-Gradient-descent/blob/main/resource/reconstructed%20image.png" width = "500" alt="" align = center />
</div><br>

## How does it work ?<br>
The diffractive optical system is strictly linear, so the propagation of the system can be expressd as following equation:
<br>

```math
\mathbf{A}=D\mathbf{X}
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

```math
\mathbf{R^\dagger} \mathbf{R}=\mathbf{I}
```

<br>

$\mthbf{a}$ is scaling factor, and $\mathbf{R}$ is unitary matrix. Since the optical intensity signal is received, an error loss function for the domain target distribution $\mathbf{C}$ can be constructed as follows using the $L^2$ -norm:
<br>

```math
Loss(x,y)=(A^\star A-C)^2=\big( 
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

The error Loss is a quadratic function of $(x^2+y^2)$, allowing the solution of $(x, y)$ to be easily obtained . For the case of a single element, there is no requirement for the phase of the solution. When considering multiple elements, the complex amplitude A propagating to the recording plane is expressed as:
<br>

```math
\mathbf{A}=\sum_{i}^{N^2}
\alpha_i R_i
\begin{bmatrix}
x_i \\
y_i
\end{bmatrix}
```
<br>

then, the intesity on recording plane is：
<br>

```math
\mathbf{A^\star A}=
\left( \sum_{j}^{N^2}
\begin{bmatrix}
x_j & y_j
\end{bmatrix}
\alpha_j R_j^T \right)
\left( \sum_{i}^{N^2} \alpha_i R_i
\begin{bmatrix}
x_i \\
y_i
\end{bmatrix}
 \right) 
```
<br>

```math
=
\sum_{i\neq j}^{N^4-N^2}
\alpha_j \alpha_i
\begin{bmatrix}
x_j & y_j
\end{bmatrix}
 R_j^T R_i
\begin{bmatrix}
x_i \\
y_i
\end{bmatrix}
 +
\sum_{i=j}^{N^2}
\alpha_j^2 \left( x_j^2+y_j^2 \right)
```
<br>

It can be seen that there are cross terms here, and the phase of the solution also needs to be considered.When considering only two elements, the loss function is look like the following equation:

<br>

```math
argmin \left( a x_1^2 + bx_2^2 +c y_1^2 +d y_2^2 +e x_1 x_2 +f y_1 y_2 - C \right)^2
```

<br>

here，For a fixed system,$(a,b,c,d,e,f)$ is a set of fixed coefficients.This is a non-convex optimization problem.By revisiting the original error loss function $Loss(x)$, we can derive its gradient with respect to $A$.

<br>

```math
\frac{\partial{\mathbf{Loss}}}{\partial{\mathbf{A}}} =2 \left(A^\star A-C \right) A^\star
```
<br>

backpropagation to the sample plane:

<br>

```math
\frac{\partial{\mathbf{Loss}}}{\partial{\mathbf{X}}}=\mathbf{D^{-1}} \left(2 \left(A^\star A-C \right) A^\star \right)
```
<br>

Update using gradient descent：

<br>

```math
\mathbf{X_new}=\mathbf{X_old}-\beta \frac{\partial{\mathbf{Loss}}}{\partial{\mathbf{X}}}
```

