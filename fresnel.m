function varargout = fresnel( U1,z,varargin)
%FRESNEL Fresnel diffraction
%  Syntax:
%  [U2,dxy2] = fresnel(U1,z,dxy1,lambda)
%  U2 = fresnel(U1,z)
%  fresnel(U1,z,...)
%
%  U1 is the wavefront of the object plane
%  U2 is the wavefront of the diffraction plane
%  U1 and U2 are all two-dimensional array
%  size of U1 and U2 are even
%  dxy1 is the sampling distance on the object plane. dxy1==[dx1,dy1]
%  if dxy1 is not input, it is set to [0.01,0.01]
%  dxy2 is the sampling distance on the diffraction plane. dxy2==[dxy2(1),dy2]
%  z is the distance between object plane and diffraction plane
%  z can be a scalar or a 2-element vector [zx,zy] to eliminate astigmatism
%  lambda is the wavelength of the laser
%
%  if there is no output, image on diffraction plane will be displayed
%  else, no image will be displayed
%
%  the origin of coordinates is at M/2+1,N/2+1
%
%  the relation between sampling distance on the two planes is:
%  dx2=lambda*z/dx1/N, dy2=lambda*z/dy1/M
%
error(nargchk(2,4,nargin))
if nargout>2
    error('Too many output arguments')
end

if length(z)==1
    z=[z,z];
end

[M,N]=size(U1);
switch nargin
    case 2
        dxy1=[0.01,0.01];
        lambda=5.32e-4;
    case 3
        dxy1=varargin{1};
        lambda=5.32e-4;
    case 4
        dxy1=varargin{1};
        lambda=varargin{2};
end

if isempty(dxy1)
    dxy1=[0.01,0.01];
end

k=2*pi/lambda;
dxy2=abs(lambda.*z./dxy1./[N,M]);

%-----------------------------------------------------
phase1=zeros(M,N);
for m=1:M
    for n=1:N
        x1=(n-N/2-1)*dxy1(1);
        y1=-(m-M/2-1)*dxy1(2);
        phase1(m,n)=exp(i*k/2*(x1^2./z(1)+y1^2./z(2)));
    end
end
U1=U1.*phase1;
clear phase1
%-----------------------------------------------------
phase2=zeros(M,N);
for m=1:M
    for n=1:N
        x2=(n-N/2-1)*dxy2(1);
        y2=-(m-M/2-1)*dxy2(2);
        phase2(m,n)=exp(i*k/2*(x2^2./z(1)+y2^2./z(2)));
    end
end
%-----------------------------------------------------
temp=zeros(M,N);
for m=1:M
    for n=1:N
        temp(m,n)=(-1).^(m+n);
    end
end
z=(z(1)+z(2))/2;
if z>0
    U2=exp(i*k*z)/(i*lambda*z)*dxy1(1)*dxy1(2)*(-1)^((M+N)/2)*phase2.*temp.*fft2(U1.*temp);
else
    U2=exp(i*k*z)/(i*lambda*z)*dxy1(1)*dxy1(2)*(-1)^((M+N)/2)*phase2.*temp.*ifft2(U1.*temp)*M*N;
end
switch nargout
    case 0
        u2=abs(U2);
        OpticImage(u2,dxy2(1),dxy2(2));xlabel('x');ylabel('y');title('Amplitude on Diffraction Plane');
    case 1
        varargout{1}=U2;
    case 2
        varargout{1}=U2;
        varargout{2}=dxy2;
end