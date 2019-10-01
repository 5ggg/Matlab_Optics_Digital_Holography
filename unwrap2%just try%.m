function [ b ] = unwrap2( a,dim,varargin )
%UNWRAP2 Unwrap a two-dimensional phase map
%  Syntax:
%  b = unwrap2(a,dim,sub,tol)
%  b = unwrap2(a,dim,sub)
%  b = unwrap2(a,dim)
%
%  a: the phase map
%  dim: the unwrapping direction
%       dim==1 : column wise
%       dim==2 : line wise
%
%       this function first calls the unwrap function to unwrap
%  every column or line of the phase map along the direction
%  specified by dim(1 or 2), then unwrap a single line or column
%  specified by sub along the direction vertical to dim. At last
%  the unwrap data (2*n*pi) added to this single line/column is
%  added to the whole phase map to make it smooth along the
%  direction vertical to dim.
%
%  sub: the subscript of that single line/column, its default
%       value is center, if sub is empty, it's set to default
%  tol: the jump tolerance, its default value is pi
error(nargchk(2,4,nargin))
if nargout>1
    error('Too many output arguments')
end
[M,N]=size(a);
if dim==1
    if rem(M,2)==0
        center=M/2+1;
    else
        center=(M+1)/2;
    end
elseif dim==2
    if rem(N,2)==0
        center=N/2+1;
    else
        center=(N+1)/2;
    end
else
    error('dim must be 1 or 2')
end
switch nargin
    case 2
        sub=center;
        tol=[];
    case 3
        sub=varargin{1};
        tol=[];
    case 4
        sub=varargin{1};
        tol=varargin{2};
end
if isempty(sub)
    sub=center;
end
b=unwrap(a,tol,dim);
if dim==1
    c=unwrap(b(sub,:),tol,2);
    c=c-b(sub,:);
    c=repmat(c,M,1);
else
    c=unwrap(b(:,sub),tol,1);
    c=c-b(:,sub);
    c=repmat(c,1,N);
end
b=b+c;