function [ varargout ] = FDADS( U1,z,varargin )
%FDADS Fresnel Diffraction with Arbitrary Diffraction plane Sampling
%  Syntax:
%  [U2,dxy2] = FDADS(U1,z,dxy1,b,FSN,xy0,lambda)
%  [U2,...] = FDADS(U1,...)
%
%  U1 : the wavefront on the object plane
%      size of U must be even
%  U2 : fresnel diffraction of U1
%  z : diffraction distance
%  z can be a scalar or a 2-element vector [zx,zy] to eliminate astigmatism
%  dxy1 : sampling interval of U1, dxy1=[dx1,dy1]
%  dxy2 : sampling interval of U2, dxy2=[dx2,dy2]
%  b : the parameter to set the dx2/dy2, b=[b1,b2]
%  FSN : the number of sampling points on the diffraction plane
%       FSN=[FSNy,FSNx] <---ATTENTION
%  xy0 : the center of the sampling region on diffraction plane
%       xy0=[x0,y0]
%  lambda : wavelength of the laser
%  
%  if there is no output, diffraction image will be displayed
%  else, no image will be displayed
%
%  the origin of coordinates is at M+1/2,N/2+1
%
%  the relation between sampling distance on the two planes is:
%  dx2=lambda*z/dx1/N/b(1),dy2=lambda*z/dy1/M/b(2)
%  THIS PROGRAM IS ADAPTED TO THE CASE OF NEGTIVE DISTANCE
%
%  -------------------------- for user to copy --------------------------
%  U2 = FDADS(U1,z,dxy1,[lambda*z/dx1/N/dx2,lambda*z/dy1/M/dy2],FSN,xy0);
%  [U2,dxy2] = FDADS(U1,z,dxy1,[b(1),N*dx1*b(1)/M/dy1],FSN,xy0);
%  [U2,dxy2] = FDADS(U1,z,dxy1,[M*dy1*b(2)/N/dx1,b(2)],FSN,xy0);
%  ----------------------------------------------------------------------
%
error(nargchk(2,7,nargin))
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
        b=[1,1];
        FSN=[M,N];
        xy0=[0,0];
        lambda=5.32e-4;
    case 3
        dxy1=varargin{1};
        b=[1,1];
        FSN=[M,N];
        xy0=[0,0];
        lambda=5.32e-4;
    case 4
        dxy1=varargin{1};
        b=varargin{2};
        FSN=[M,N];
        xy0=[0,0];
        lambda=5.32e-4;
    case 5
        dxy1=varargin{1};
        b=varargin{2};
        FSN=varargin{3};
        xy0=[0,0];
        lambda=5.32e-4;
    case 6
        dxy1=varargin{1};
        b=varargin{2};
        FSN=varargin{3};
        xy0=varargin{4};
        lambda=5.32e-4;
    case 7
        dxy1=varargin{1};
        b=varargin{2};
        FSN=varargin{3};
        xy0=varargin{4};
        lambda=varargin{5};
end

if isempty(dxy1)
    dxy1=[0.01,0.01];
end
if isempty(b)
    b=[1,1];
end
if isempty(FSN)
    FSN=[M,N];
end
if isempty(xy0)
    xy0=[0,0];
end
%--------------------------------------------------------------
[X,Y]=meshgrid((-N/2:N/2-1)*dxy1(1),(M/2:-1:1-M/2)*dxy1(2));
U1=U1.*exp(i*pi/lambda*(X.^2./z(1)+Y.^2./z(2)));
clear X Y
%--------------------------------------------------------------
zav=(z(1)+z(2))/2;
f0=xy0./lambda./abs(z);
if zav>=0
    [U2,dfxy] = FAFS(U1,dxy1,b,FSN,f0);
else 
    [U2,dfxy] = IFASS(U1,dxy1,b,FSN,f0);
end
clear U1;
dxy2=dfxy.*lambda.*abs(z);
%--------------------------------------------------------------
x2=(-FSN(2)/2:FSN(2)/2-1)*dxy2(1)+xy0(1);
y2=(FSN(1)/2:-1:1-FSN(1)/2)*dxy2(2)+xy0(2);
[X,Y]=meshgrid(x2,y2);
U2=U2.*exp(i*pi/lambda*(X.^2./z(1)+Y.^2./z(2)))*exp(i*2*pi/lambda*zav)/i/lambda/zav;
clear X Y
%--------------------------------------------------------------
switch nargout
    case 0
        imagesc(x2,y2,abs(U2));colormap(gray);axis xy image;
        xlabel('x');ylabel('y');title('Amplitude on Diffraction Plane');
    case 1
        varargout{1}=U2;
    case 2
        varargout{1}=U2;
        varargout{2}=dxy2;
end