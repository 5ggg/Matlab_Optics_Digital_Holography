function varargout = invfourier( F,varargin)
%INVFOURIER Two-dimensional invert fourier transform
%  Syntax:
%  [U,dx,dy] = invfourier(F,dfx,dfy)
%  U = invfourier(F)
%  invfourier(F,...)
%
%  U is the wavefront on the object plane
%  F is the frequence distribution of U
%  F must be a two-dimensional array
%  size of F must be even
%  dx is the sampling distance along the axis x in space domain
%  dy is the sampling distance along the axis y in space domain
%  dfx is the sampling distance along the axis fx in frequency domain
%  dfy is the sampling distance along the axis fy in frequency domain
%  if dfx and dfy are not inputted, they are set to 1/N and 1/M
%
%  if there is no output, object image will be displayed
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
[M,N]=size(F);
temp=zeros(M,N);
for m=1:M
    for n=1:N
        temp(m,n)=(-1).^(m+n);
    end
end
switch nargin
    case 1
        dfx=1/N;
        dfy=1/M;
    case 2
        dfx=varargin{1};
        dfy=dfx;
    case 3
        dfx=varargin{1};
        dfy=varargin{2};
end
U=temp.*ifft2(F.*temp)*(-1)^((M+N)/2)*N*M*dfx*dfy;
switch nargout
    case 0
        u=abs(U);
        OpticImage(u,1/dfx/N,1/dfy/M);xlabel('x');ylabel('y');title('Amplitude in Space Domain');
    case 1
        varargout{1}=U;
    case 2
        varargout{1}=U;
        varargout{2}=1/dfx/N;
    case 3
        varargout{1}=U;
        varargout{2}=1/dfx/N;
        varargout{3}=1/dfy/M;
end