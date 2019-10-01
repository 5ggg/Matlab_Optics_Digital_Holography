function [ varargout ] = OpticImage( U,varargin )
%OPTICIMAGE Display an optical image OR output the coordinate vector
%  Syntax:
%  [vx,vy] = OpticImage(U,dx,dy,xy0)
%  [vx,vy] = OpticImage(U,...)
%  vx = OpticImage(U,...)
%  OpticImage(U,...)
%
%  ------------------------------------------------------------------------
%  U can be a one,two or three-dimensioal array
%  U can be image/data array or size array
%  if U is a scalar or a 1 by 2 vector, it is deemed as a size array in the
%  case that there is output coordinate vector
%  if there is no output, the function of the program is to plot or
%  display, so U is deemed as image/data array when there is no output
%  ------------------------------------------------------------------------
%  the size of U is (M,N) or (M,N,3)
%  dx is the distance between two sampling points along the axis x
%  dy is the distance between two sampling points along the axis y
%  xy0 is the coordinate of the center of the image, xy0=[x0,y0]
%  if there is no xy0 in the input, it is [0,0]
%  if dx and dy are not inputted, they are set to 1
%  vx is the coordinate vector along axis x
%  vy is the coordinate vector along axis y
%  vx and vy are all row arrays
%
%  if there is no output, the image will be displayed
%  else, the image will not be displayed
%
%  if M is even
%  the origin of coordinates is at M/2+1
%  if M is odd
%  the origin of coordinates is at (M+1)/2
%  N is the same
%
error(nargchk(1,4,nargin))
if nargout>2
    error('Too many output arguments')
end
switch nargin
    case 1
        dx=1;
        dy=1;
        xy0=[0,0];
    case 2
        dx=varargin{1};
        dy=dx;
        xy0=[0,0];
    case 3
        dx=varargin{1};
        dy=varargin{2};
        xy0=[0,0];
    case 4
        dx=varargin{1};
        dy=varargin{2};
        xy0=varargin{3};
end
%----------construct vx and vy----------
[M,N,P]=size(U);
if M==1 && N==1 && P==1 && nargout~=0
    M=U;
    N=U;
end
if M==1 && N==2 && P==1 && nargout~=0
    M=U(1);
    N=U(2);
end
if rem(N,2)==0
    vx=[-N/2:N/2-1]*dx;
else
    vx=[(1-N)/2:(N-1)/2]*dx;
end
if rem(M,2)==0
    vy=[M/2:-1:1-M/2]*dy;
else
    vy=[(M-1)/2:-1:(1-M)/2]*dy;
end
vx=vx+xy0(1);
vy=vy+xy0(2);
%---------------------------------------
if P==3
    error('The input matrix must be of size [MxN] or [MxNx3]')
end
%---------------------------------------
switch nargout
    case 0
        if P==1;
            if M==1
                plot(vx,U);
            elseif N==1
                plot(U,vy);
            else
                imagesc(vx,vy,U);colormap(gray);axis xy image;
            end
        else
            image(vx,vy,U);axis xy image;
        end
    case 1
        if N==1
            varargout{1}=vy;
        else
            varargout{1}=vx;
        end
    case 2
        varargout{1}=vx;
        varargout{2}=vy;
end