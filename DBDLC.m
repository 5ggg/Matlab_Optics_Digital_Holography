function [ U2 ] = DBDLC( U1,z,dxy1,t,center,RPN,varargin )
%DBDLC Diffraction By Discrete Linear Convolution
%  %  Syntax:
%  U2 = DBDLC(U1,z,dxy1,t,center,RPN,'PropertyName','PropertyValue',...  );
%
%  U1 : the wavefront on the x1 plane
%  U2 : a part of the free space diffraction of U1 on x2 plane
%  size of U1 and U2 must be even
%  z : the distance between these two planes
%  dxy1 : the sampling interval of U1
%  dxy2 : the sampling interval of U2
%  t : the parameter to decide dxy2, dxy2=dxy1/t, t must be an integer
%  center : 1 by 2 array, it is the position of U2's center
%           center=[centerx,centery]
%  RPN : 1 by 2 array, it is the point number of U2
%        (U2 is a RPN(1) by RPN(2) array)
%        RPN=[RPNy,RPNx]  <== ATTENTION
%
%--------------------------------------------------------------------------
%  PropertyName and PropertyValue:
%
%  inclination       {k} | rs | off
%  it decides whether and which inclination factor is considered in the
%  integrand
%       k - use Kirchhoff inclination factor
%       rs - use Rayleigh-Sommerfeld inclination factor
%       off - inclination factor is not considered
%
%  interpolation     {zero} | sinc
%  the interpolation method of U1
%       zero - interpolate with zeros, in this case, the program is equal
%              to direct integral of Kirchhoff diffraction formula
%       sinc - sinc interpolation by inverse fourier transform of an array
%              which is formed by pading the frequency of U1 with zeros
%  ------------------------------------------------------------------------
error(nargchk(6,10,nargin))
for n=1:length(varargin)
    if ~ischar(varargin{n})
        error('Property names and values must be characters')
    end
end
parray=[0,0];
property=struct('name',{'inclination','interpolate'});
property(1).value={'k','rs','off',''};
property(2).value={'zero','sinc',''};
for l=1:2:length(varargin)
    namefound=0;
    valuefound=0;
    m=0;
    n=0;
    while ~namefound && m<length(parray)
        m=m+1;
        if strcmp(varargin{l},property(m).name)
            namefound=1;
        end
    end
    while namefound && ~valuefound && n<length(property(m).value)
        n=n+1;
        if strcmp(varargin{l+1},property(m).value{n})
            valuefound=1;
            parray(m)=n;
        end
    end
    if namefound==0
        error('wrong property name')
    elseif valuefound==0
        error('wrong property value')
    end
end
%  ------------------------------------------------------------------------
load lambda;
k=2*pi/lambda;
[M,N]=size(U1);
M=M*t;
N=N*t;
dxy2=dxy1/t;
if parray(2)==0 || parray(2)==1 || parray(2)==3
    temp=U1;
    U1=zeros(M,N);
    U1(1:t:M-t+1,1:t:N-t+1)=temp;
    clear temp
elseif parray(2)==2
    FU1=fourier(U1);
    FU1=paste(zeros(M,N),FU1);
    U1=invfourier(FU1);
end
%--------------------------------------------------------------------------
[P,Q]=meshgrid((1-N/2-RPN(2)/2:N/2+RPN(2)/2-1)*dxy2(1)+center(1),(M/2+RPN(1)/2-1:-1:1-M/2-RPN(1)/2)*dxy2(2)+center(2));
r=sqrt(P.^2+Q.^2+z.^2);
clear P Q
if parray(1)==0 || parray(1)==1 || parray(1)==4
    h=exp(i*k*r)./r.*(z./r+1)/2;
elseif parray(1)==2
    h=exp(i*k*r)*z./r.^2;
else
    h=exp(i*k*r)./r;
end
clear r
H=fft2(h);
clear h
%--------------------------------------------------------------------------
U1=paste(zeros(M+RPN(1)-1,N+RPN(2)-1),U1,M/2+1,N/2+1);
F=fft2(U1);
clear U1
%--------------------------------------------------------------------------
F=F.*H;
clear H
%--------------------------------------------------------------------------
[P,Q]=meshgrid(0:N+RPN(2)-2,0:M+RPN(1)-2);
fp=exp(i*2*pi*((M-1)*Q/(M+RPN(1)-1)+(N-1)*P/(N+RPN(2)-1)));
clear P Q
%--------------------------------------------------------------------------
F=F.*fp;
clear fp
%--------------------------------------------------------------------------
U2=ifft2(F);
U2=U2(1:RPN(1),1:RPN(2));
U2=-i*U2/lambda*dxy1(1)*dxy1(2);