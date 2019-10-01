function [ varargout ] = FAFS( U,varargin )
%FAFS Fourier transform with Arbitrary Frequency Sampling
%  Syntax:
%  [F,dfxy] = FAFS(U,dxy,b,FSN,f0)
%  [F,...] = FAFS(U,...)
%
%  U : the wavefront on the object plane
%      size of U must be even
%  F : frequency distribution of U
%  dxy : sampling interval of U, dxy=[dx,dy]
%  dfxy : sampling interval in frequency domain, dfxy=[dfx,dfy]
%  b : the parameter to set the dfx/dfy, b=[b1,b2]
%  FSN : the number of sampling points on the frequency plane
%       FSN=[FSNy,FSNx] <---ATTENTION
%  f0 : the center of the sampling region on frequency plane
%       f0=[f0x,f0y]
%  
%  if there is no output, frequency image will be displayed
%  else, no image will be displayed
%
%  the origin of coordinates is at M+1/2,N/2+1
%
%  the relation between sampling distance on the two planes is:
%  dfx=1/dx/N/b(1),dfy=1/dy/M/b(2)
%
error(nargchk(1,5,nargin))
if nargout>2
    error('Too many output arguments')
end
[M,N]=size(U);
switch nargin
    case 1
        dxy=[1,1];
        b=[1,1];
        FSN=[M,N];
        f0=[0,0];
    case 2
        dxy=varargin{1};
        b=[1,1];
        FSN=[M,N];
        f0=[0,0];
    case 3
        dxy=varargin{1};
        b=varargin{2};
        FSN=[M,N];
        f0=[0,0];
    case 4
        dxy=varargin{1};
        b=varargin{2};
        FSN=varargin{3};
        f0=[0,0];
    case 5
        dxy=varargin{1};
        b=varargin{2};
        FSN=varargin{3};
        f0=varargin{4};
end
%----------------------------------------
[P,Q]=meshgrid(0:N-1,0:M-1);
phase=exp(i*pi*((P+1)*FSN(2)/b(1)/N+(Q+1)*FSN(1)/b(2)/M-2*f0(1)*dxy(1)*(P+1)+2*f0(2)*dxy(2)*(Q+1)-P.^2/b(1)/N-Q.^2/b(2)/M));
U=U.*phase;
clear phase;
U=paste(zeros(FSN(1)+M-1,FSN(2)+N-1),U,M/2+1,N/2+1);
FU=fft2(U);
clear U
%----------------------------------------
[P,Q]=meshgrid(1-N:FSN(2)-1,1-M:FSN(1)-1);
h=exp(i*pi*(P.^2/b(1)/N+Q.^2/b(2)/M));
Fh=fft2(h);
clear h
%----------------------------------------
FU=FU.*Fh;
clear Fh
%----------------------------------------
[P,Q]=meshgrid(0:FSN(2)+N-2,0:FSN(1)+M-2);
fp=exp(i*2*pi*((N-1)/(FSN(2)+N-1)*P+(M-1)/(FSN(1)+M-1)*Q));
FU=FU.*fp;
clear fp P Q
%----------------------------------------
F=ifft2(FU);
clear FU
F=F(1:FSN(1),1:FSN(2));
%----------------------------------------
[P,Q]=meshgrid(1:FSN(2),1:FSN(1));
phase=exp(i*pi*((P-FSN(2)/2-(FSN(2)+N)/N)/b(1)+(Q-FSN(1)/2-(FSN(1)+M)/M)/b(2)+...
    2*f0(1)*(N/2+1)*dxy(1)-2*f0(2)*(M/2+1)*dxy(2)-...
    (P-1).^2/b(1)/N-(Q-1).^2/b(2)/M))*dxy(1)*dxy(2);
clear P Q
F=F.*phase;
%----------------------------------------
switch nargout
    case 0
        f=abs(F);
        fx=(-FSN(2)/2:FSN(2)/2-1)/dxy(1)/N/b(1)+f0(1);
        fy=(FSN(1)/2:-1:1-FSN(1)/2)/dxy(2)/M/b(2)+f0(2);
        imagesc(fx,fy,f);colormap(gray);axis xy image;
        xlabel('fx');ylabel('fy');title('Amplitude of Frequency Spectrum');
    case 1
        varargout{1}=F;
    case 2
        varargout{1}=F;
        varargout{2}=[1/dxy(1)/N/b(1),1/dxy(2)/M/b(2)];
end