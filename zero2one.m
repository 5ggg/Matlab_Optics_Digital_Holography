function  varargout  = zero2one( varargin )
%ZERO2ONE Scale the values of the array into range 0 - 1
%  Syntax:
%  [uo1,uo2,...]=zero2one(ui1,ui2,...)
%
%  ui must be a real array
%  if all values in ui are the same but not zero,
%  uo is an all-one array
%  if ui is an all-zero array,
%  uo is equal to ui
%
for n=1:nargin
    maxu=max(varargin{n}(:));
    minu=min(varargin{n}(:));
    if maxu==minu
        if maxu==0
            varargout{n}=varargin{n};
        end
        if maxu~=0
            varargout{n}=varargin{n}/maxu;
        end
    else
    varargout{n}=(varargin{n}-minu)/(maxu-minu);
    end
end