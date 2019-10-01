function varargout = fourier( U,varargin )
%FOURIER Two-dimensional fourier transform
%  Syntax:
%  [F,dfx,dfy] = fourier(U,dx,dy)
%  F = fourier(U)
%  fourier(U,...)
%
%  U is the wavefront on the object plane
%  U must be a two-dimensional array
%  size of U must be even
%  F is the frequency distribution of U
%  dx is the sampling distance along the axis x in space domain
%  dy is the sampling distance along the axis y in space domain
%  if dx and dy are not inputted, they are set to 1
%  dfx is the sampling distance along the axis fx in frequency domain
%  dfy is the sampling distance along the axis fy in frequency domain
%  
%  if there is no output, frequency image will be displayed
%  else, no image will be displayed
%
%  the origin of coordinates is at M/2+1,N/2+1
%
%  the relation between sampling distance on the two planes is:
%  dfx=1/dx/N, dfy=1/dy/M
%
error(nargchk(1,3,nargin))
if nargout>3
    error('Too many output arguments')
end
[M,N]=size(U);
temp=zeros(M,N);
for m=1:M
    for n=1:N
        temp(m,n)=(-1)^(m+n);
    end
end
switch nargin
    case 1
        dx=1;
        dy=1;
    case 2
        dx=varargin{1};
        dy=dx;
    case 3
        dx=varargin{1};
        dy=varargin{2};
end
F=temp.*fft2(U.*temp)*(-1)^((M+N)/2)*dx*dy;
switch nargout
    case 0
        f=abs(F);
        OpticImage(f,1/dx/N,1/dy/M);xlabel('fx');ylabel('fy');title('Amplitude of Frequency Spectrum');
    case 1
        varargout{1}=F;
    case 2
        varargout{1}=F;
        varargout{2}=1/dx/N;
    case 3
        varargout{1}=F;
        varargout{2}=1/dx/N;
        varargout{3}=1/dy/M;
end