function [ mark,varargout ] = AJMF( a,varargin )             
          
%AJMF Abnormal jump marking and filtering in a phase map
%  Syntax:
%  [mark,filtered]=AJMF(a,filtering_mehod,filter_size)
%  mark=AJMF(a)
%
%  a is the phase map 
%  filter_method specifies the method of filtering, there are
%  two alternatives: 'mean' and 'median'
%  filter_size specifies the size of the filter
%  mark is a logical array which marks the abnormal phase jump points
%  filtered is the filtered phase map
%  ------------------------------------------------------------------------
%  Reference:
%  [1]
%  吴禄慎 任丹 吴魁  一种新的区域增长相位去包裹算法
%  南昌大学机电工程学院江西南昌330029)
%  南昌大学电子信息工程学院江西南昌330029)
%  ------------------------------------------------------------------------
error(nargchk(1,3,nargin))
if nargout>2 
    error('Too many output arguments')
end
[M,N]=size(a);
mark=logical(zeros(M,N));
d=nint((a(1:M-1,2:N)-a(1:M-1,1:N-1))/2/pi);   % d=A
d=d+nint((a(2:M,2:N)-a(1:M-1,2:N))/2/pi);     % d=A+B
d=d+nint((a(2:M,1:N-1)-a(2:M,2:N))/2/pi);     % d=A+B+C
d=d+nint((a(1:M-1,1:N-1)-a(2:M,1:N-1))/2/pi); % d=A+B+C+D
warning off MATLAB:conversionToLogical
d=logical(d);
[r,c]=find(d);
add2r=[0,0,1,1];
add2c=[0,1,1,0];
for n=1:length(r)
    r4=r(n)+add2r;
    c4=c(n)+add2c;
    d=1;
    k=0;
    while d
        k=k+1;
        r3=r4;
        c3=c4;
        r3(k)=[];
        c3(k)=[];
        d=nint((a(r3(2),c3(2))-a(r3(1),c3(1)))/2/pi)+...
            nint((a(r3(3),c3(3))-a(r3(2),c3(2)))/2/pi)+...
            nint((a(r3(1),c3(1))-a(r3(3),c3(3)))/2/pi);
    end
    mark(r4(k),c4(k))=1;
end
% -------- filter abnormal jump points in the phase map --------
fta=a;
switch nargin
    case 1
        fm='mean';
        fs=[3,3];
    case 2
        fm=varargin{1};
        fs=[3,3];
    case 3
        fm=varargin{1};
        fs=varargin{2};
end
if ~isequal(fm,'mean') && ~isequal(fm,'median')
    error('wrong filtering method')
end
up=floor(fs(1)/2);
dn=fs(1)-up-1;
lft=floor(fs(2)/2);
rt=fs(2)-lft-1;
if nargout==2
    [r,c]=find(mark);
    for n=1:length(r)
        t=a(max(r(n)-up,1):min(r(n)+dn,M),max(c(n)-lft,1):min(c(n)+rt,N));
        eval(['fta(r(n),c(n))=',fm,'(t(:));']);
    end
    varargout{1}=fta;
end

function b=nint(a)
%  round numbers between -1 and 1 to nearest integer
%  0.5 and -0.5 are rounded to 0
b=sign(a)-round(sign(a)-a);
