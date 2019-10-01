function [ varargout ] = frefilter( Uin,ftr,varargin )
%FREFILTER Filtering in frequency domain
%  Syntax:
%  [Uout,dfx,dfy]=frefilter(Uin,ftr,dx,dy)
%  Uout=frefilter(Uin,ftr)
%  frefilter(Uin,ftr...)
%
%  Uin is the input wavefront distribution
%  Uout is the output wavefront distribution
%  ftr is the filter
%  size of Uin must be even
%  Uout has the same size as Uin
%  if size of ftr is different from Uin,
%  it will be modified so that they have the same size
%  dx is the sampling distance along the axis x in space domain
%  dy is the sampling distance along the axis y in space domain
%  if dx and dy are not inputted, they are set to 1
%  dfx is the sampling distance along the axis fx in frequency domain
%  dfy is the sampling distance along the axis fy in frequency domain
%  Uin and Uout have the same sampling distance
%
%  if there is no outnput, result will be displayed by image
%  else, no image will be displayed
%
%  the origin of coordinates is at M/2+1,N/2+1
%
%  the sampling distance of the filter in frequency domain is:
%  dfx=1/dx/N, dfy=1/dy/M
%
error(nargchk(2,4,nargin))
if nargout>3
    error('Too many output arguments')
end
[M,N]=size(Uin);
[Mf,Nf]=size(ftr);
filter=zeros(M,N);
if Mf==M && Nf==N
    filter=ftr;
else
    filter=paste(filter,ftr);
end
F=fourier(Uin);
Ft=F.*filter;
Uout=invfourier(Ft);
switch nargin
    case 2
        dx=1;
        dy=1;
    case 3
        dx=varargin{1};
        dy=dx;
    case 4
        dx=varargin{1};
        dy=varargin{2};
end
switch nargout
    case 0
        uout=abs(Uout);
        OpticImage(uout,dx,dy);xlabel('x');ylabel('y');title('After frequency filtering');
    case 1
        varargout{1}=Uout;
    case 2
        varargout{1}=Uout;
        varargout{2}=1/dx/N;
    case 3
        varargout{1}=Uout;
        varargout{2}=1/dx/N;
        varargout{3}=1/dy/M;
end