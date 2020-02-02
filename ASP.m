function varargout = ASP( U1,z,dxy1,lambda,varargin )

%ASP Diffraction calculation by Angular Spectrum Propagation method
%  Syntax:
%  [U2,dxy2] = ASP(U1,z,dxy1,'PropertyName','PropertyValue',...)
%  [U2,...] = ASP(U1,z,dxy1,...)
%  ASP(U1,z,dxy1,...)
%
%  U1 is the wavefront of the object plane
%  U2 is the wavefront of the diffraction plane
%  U1 and U2 are all two-dimensional array
%  size of U1 and U2 are even
%  z is the distance between object plane and diffraction plane
%  dxy1 is the sampling distance of the object, dxy1=[dx1,dy1]
%  lambda is the wavelength of the laser
%
%  if there is no output, image on diffraction plane will be displayed
%  else, no image will be displayed
%
%  the origin of coordinates is at M/2+1,N/2+1
%
%--------------------------------------------------------------------------
%  PropertyName and PropertyValue:
%  
%  piz               {off} | t
%  pad the input array with zeros
%       off - do not pad
%       t - paste U1 to an all zeros array whose size is t*size(U1)
%
%  iiz               {off} | t
%  interpolate the input array with zeros
%       off - do not interpolate
%       t - interpolate t-1 points between every two points
%
%  pfz               {off} | t
%  pad the frequency array with zeros
%       off - do not pad
%       t - paste the frequency array(F) to an all zeros array whose
%           size is t*size(F)
%
%  FTmethod          {fourier} | b,FSN,f0
%  which method to be use to realize the fourier transform
%       fourier - traditional fourier transform using single fft
%       b,FSN,f0 - FAFS using 3 ffts, b,FSN,f0 are the parameters needed
%
%  IFTmethod         {invfourier} | b,SSN,xy0
%  which method to be use to realize the inverse fourier transform
%       invfourier - traditional inverse fourier transform using single fft
%       b,SSN,xy0 - IFASS using 3 ffts, b,SSN,xy0 are the parameters needed
%--------------------------------------------------------------------------
error(nargchk(4,14,nargin))
if nargout>2
    error('Too many output arguments')
end
for n=1:length(varargin)
    if ~ischar(varargin{n})
        error('Property names and values must be characters')
    end
end
%  ----------------------construct the property array----------------------
parray=[0,0,0,0,0];                                                         % initialize the property array, the property array
                                                                            % is used to store the property specified by the user
freepv={'1','1','1','',''};                                                 % initialize the free property value array, free property
                                                                            % values do not fall into those values in the property structure
property=struct('name',{'piz','iiz','pfz','FTmethod','IFTmethod'});         % construct the property structure,
property(1).value={'off',''};                                               % which stores all possible properties
property(2).value={'off',''};
property(3).value={'off',''};
property(4).value={'fourier',''};
property(5).value={'invfourier',''};
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
    %----------------------------------------------
    if namefound==1 && valuefound==0
        parray(m)=3;
        freepv{m}=varargin{l+1};
        valuefound=1;
    end
    %----------------------------------------------
    if namefound==0
        error('wrong property name')
    elseif valuefound==0
        error('wrong property value')
    end
end
%--------------------------------------------------------------------------
k=2*pi/lambda;
if parray(1)==3
    t=str2num(freepv{1});
    U1=paste(zeros(t*size(U1)),U1);
end
if parray(2)==3
    t=str2num(freepv{2});
    temp=U1;
    U1=zeros(t*size(U1));
    U1(1:t:end,1:t:end)=temp;
    clear temp;
end
%---------------------- implement fourier transform ----------------------
if parray(4)~=3
    [F,dfxy(1),dfxy(2)]=fourier(U1,dxy1(1),dxy1(2));
else
    eval(['[F,dfxy] = FAFS(U1,dxy1,',freepv{4},');']);
end
clear U1
if parray(3)==3
    t=str2num(freepv{3});
    F=paste(zeros(t*size(F)),F);
end
%---------- construct the transfer function in frequency domain ----------
[M,N]=size(F);
H=zeros(M,N);
for m=1:M
    for n=1:N
        fx=(n-N/2-1)*dfxy(1);
        fy=-(m-M/2-1)*dfxy(2);
        H(m,n)=exp(i*2*pi*z*sqrt((1/lambda)^2-fx^2-fy^2));
    end
end
%-------------------------------------------------------------------------
F=F.*H;
clear H;
%------------------ implement inverse fourier transform ------------------
if parray(5)~=3 && nargout~=0
    [U2,dxy2(1),dxy2(2)]=invfourier(F,dfxy(1),dfxy(2));
elseif parray(5)==3 && nargout~=0
    eval(['[U2,dxy2] = IFASS(F,dfxy,',freepv{5},');']);
elseif parray(5)~=3 && nargout==0
    invfourier(F,dfxy(1),dfxy(2));
else
    eval(['IFASS(F,dfxy,',freepv{5},');']);
end
%--------------------------------------------------------------------------
switch nargout
    case 1
        varargout{1}=U2;
    case 2
        varargout{1}=U2;
        varargout{2}=dxy2;
end
