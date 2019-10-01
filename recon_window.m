function varargout = recon_window(varargin)
% RECON_WINDOW M-file for recon_window.fig
%      RECON_WINDOW, by itself, creates a new RECON_WINDOW or raises the existing
%      singleton*.
%
%      H = RECON_WINDOW returns the handle to a new RECON_WINDOW or the handle to
%      the existing singleton*.
%
%      RECON_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECON_WINDOW.M with the given input arguments.
%
%      RECON_WINDOW('Property','Value',...) creates a new RECON_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before recon_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to recon_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help recon_window

% Last Modified by GUIDE v2.5 01-Oct-2007 22:13:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @recon_window_OpeningFcn, ...
    'gui_OutputFcn',  @recon_window_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before recon_window is made visible.
function recon_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to recon_window (see VARARGIN)
axes(handles.prev_axes)
imagesc(ones(576,768)),colormap(gray);
axis equal tight;

set(handles.holo_lbox,'String',cell(1,0),'value',1);

handles.recons=[];

handles.distxok=0;
handles.distyok=0;

handles.prefix='U_';

handles.ondisp.im=[];
handles.ondisp.dxy2=[];
handles.ondisp.center=[];

handles.hwp.M=576;
handles.hwp.N=768;
handles.hwp.dx=0.0086;
handles.hwp.dy=0.0083;
handles.hwp.lambda=532;

handles.reconps.dist=[];
handles.reconps.b=[1,1];
handles.reconps.MN2=[handles.hwp.M,handles.hwp.N];
handles.reconps.center=[0,0];
handles.reconps.dxy2o=[];
handles.reconps.dxy2=[];

if nargin > 4
    for n=1:2:length(varargin)
        if strcmpi(varargin{n},'hwp')
            handles.hwp=varargin{n+1};
            set(handles.dx_edit,'string',num2str(handles.hwp.dx));
            set(handles.dy_edit,'string',num2str(handles.hwp.dy));
            set(handles.lambda_edit,'string',num2str(handles.hwp.lambda));
            handles.reconps.MN2=[handles.hwp.M,handles.hwp.N];
        end
        if strcmpi(varargin{n},'holograms')
            handles.holograms=varargin{n+1};
            items = sort(fieldnames(handles.holograms));
            set(handles.holo_lbox,'String',items,'value',1);
            [handles.hwp.M,handles.hwp.N]=size(handles.holograms.(items{1}));
        end
        if strcmpi(varargin{n},'reconps')
            reconps=varargin{n+1};
            if ~isempty(reconps.b) && ~isempty(reconps.MN2)...
                    && ~isempty(reconps.center) && ~isempty(reconps.dxy2o)...
                    && ~isempty(reconps.dxy2) && ~isempty(reconps.dist)
                handles.reconps=reconps;
                
                if ~isequal(reconps.dxy2o,handles.hwp.lambda.*1e-6.*reconps.dist./...
                        [handles.hwp.dx,handles.hwp.dy]./[handles.hwp.N,handles.hwp.M])
                    selection = questdlg({'The current reconstruction distance dose not accord with other';...
                            'reconstruction parameters previously set, which do you want to';'adjust to accord with the other?'},...
                        'Adjust parameters','Distance','Others','Others');
                    if strcmp(selection,'Distance')
                        handles.reconps.dist=[handles.hwp.dx,handles.hwp.dy].*handles.reconps.dxy2o.*...
                            [handles.hwp.N,handles.hwp.M]./handles.hwp.lambda./1e-6;
                    else
                        handles.reconps.dxy2o=handles.hwp.lambda.*1e-6.*handles.reconps.dist./...
                            [handles.hwp.dx,handles.hwp.dy]./[handles.hwp.N,handles.hwp.M];
                        handles.reconps.b=[1,1];
                        handles.reconps.center=[0,0];
                        handles.reconps.dxy2=handles.reconps.dxy2o./handles.reconps.b;
                        handles.reconps.MN2=[handles.hwp.M,handles.hwp.N];
                    end
                end 
                
                left=handles.reconps.center(1)-handles.reconps.MN2(2)./2.*handles.reconps.dxy2(1);
                right=handles.reconps.center(1)+(handles.reconps.MN2(2)./2-1).*handles.reconps.dxy2(1);
                down=handles.reconps.center(2)-handles.reconps.MN2(1)./2.*handles.reconps.dxy2(2);
                up=handles.reconps.center(2)+(handles.reconps.MN2(1)./2-1).*handles.reconps.dxy2(2);
                
                set(handles.dx2_edit2,'string',num2str(handles.reconps.b(1)));
                set(handles.dy2_edit2,'string',num2str(handles.reconps.b(2)));
                set(handles.N2_edit,'string',num2str(handles.reconps.MN2(2))); % <==
                set(handles.M2_edit,'string',num2str(handles.reconps.MN2(1))); % <==
                set(handles.dx2_edit1,'string',num2str(handles.reconps.dxy2o(1)));
                set(handles.dy2_edit1,'string',num2str(handles.reconps.dxy2o(2)));
                set(handles.dx2_edit3,'string',num2str(handles.reconps.dxy2(1)));
                set(handles.dy2_edit3,'string',num2str(handles.reconps.dxy2(2)));
                set(handles.regionx_edit,'string',['[',num2str(left),',',num2str(right),']']);
                set(handles.regiony_edit,'string',['[',num2str(down),',',num2str(up),']']);
                set(handles.setdistx_edit,'string',num2str(handles.reconps.dist(1)));
                set(handles.setdisty_edit,'string',num2str(handles.reconps.dist(2)));
            elseif ~isempty(reconps.dist)
                handles.reconps.dist=reconps.dist;
                set(handles.dx2_edit2,'string',num2str(handles.reconps.b(1)));
                set(handles.dy2_edit2,'string',num2str(handles.reconps.b(2)));
                set(handles.N2_edit,'string',num2str(handles.reconps.MN2(2))); % <==
                set(handles.M2_edit,'string',num2str(handles.reconps.MN2(1))); % <==
                set(handles.setdistx_edit,'string',num2str(handles.reconps.dist(1)));
                set(handles.setdisty_edit,'string',num2str(handles.reconps.dist(2)));
                handles.reconps.dxy2o=[handles.hwp.lambda.*1e-6.*handles.reconps.dist(1)./handles.hwp.dx./handles.hwp.N,...
                        handles.hwp.lambda.*1e-6.*handles.reconps.dist(2)./handles.hwp.dy./handles.hwp.M];
                handles.reconps.dxy2=handles.reconps.dxy2o./handles.reconps.b;
                if ~isempty(handles.reconps.dxy2o)
                    set(handles.dx2_edit1,'string',num2str(handles.reconps.dxy2o(1)));
                    set(handles.dy2_edit1,'string',num2str(handles.reconps.dxy2o(2)));
                end
                if ~isempty(handles.reconps.dxy2)
                    set(handles.dx2_edit3,'string',num2str(handles.reconps.dxy2(1)));
                    set(handles.dy2_edit3,'string',num2str(handles.reconps.dxy2(2)));
                end
                left=handles.reconps.center(1)-handles.reconps.MN2(2)./2.*handles.reconps.dxy2(1);
                right=handles.reconps.center(1)+(handles.reconps.MN2(2)./2-1).*handles.reconps.dxy2(1);
                down=handles.reconps.center(2)-handles.reconps.MN2(1)./2.*handles.reconps.dxy2(2);
                up=handles.reconps.center(2)+(handles.reconps.MN2(1)./2-1).*handles.reconps.dxy2(2);
                set(handles.regionx_edit,'string',['[',num2str(left),',',num2str(right),']']);
                set(handles.regiony_edit,'string',['[',num2str(down),',',num2str(up),']']);
            else
                set(handles.dx2_edit2,'string',num2str(handles.reconps.b(1)));
                set(handles.dy2_edit2,'string',num2str(handles.reconps.b(2)));
                set(handles.N2_edit,'string',num2str(handles.reconps.MN2(2))); % <==
                set(handles.M2_edit,'string',num2str(handles.reconps.MN2(1))); % <==
            end
        end
    end
end

if ~isempty(handles.reconps.dist)
    handles.distxok=1;
    handles.distyok=1;
    set(handles.dx2_edit2,'enable','on')
    set(handles.dy2_edit2,'enable','on')
    set(handles.dx2_edit3,'enable','on')
    set(handles.dy2_edit3,'enable','on')
    set(handles.N2_edit,'enable','on')
    set(handles.M2_edit,'enable','on')
    set(handles.regionx_edit,'enable','on')
    set(handles.regiony_edit,'enable','on')
    set(handles.dy2e2dx2,'enable','on')
    set(handles.dx2e2dy2,'enable','on')
    set(handles.singlefft_toggle,'enable','on')
end

% Choose default command line output for recon_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes recon_window wait for user response (see UIRESUME)
uiwait(handles.recon_window);


% --- Outputs from this function are returned to the command line.
function varargout = recon_window_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if isempty(findobj('type','figure','tag','recon_window'))
    switch nargout
        case 1
            varargout{1}=[];
        case 2
            varargout{1}=[];
            varargout{2}=[];
        case 3
            varargout{1}=[];
            varargout{2}=[];
            varargout{3}=[];
    end
    return
end

if strcmp(get(handles.recon_button,'enable'),'on')
    handles.hwp=[];
    handles.reconps=[];
end

switch nargout
    case 1
        varargout{1}=handles.recons;
    case 2
        varargout{1}=handles.recons;
        varargout{2}=handles.hwp;
    case 3
        varargout{1}=handles.recons;
        varargout{2}=handles.hwp;
        varargout{3}=handles.reconps;
end

guidata(hObject,handles)

delete(handles.recon_window)


% --- Executes during object creation, after setting all properties.
function holo_lbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to holo_lbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in holo_lbox.
function holo_lbox_Callback(hObject, eventdata, handles)
% hObject    handle to holo_lbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns holo_lbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from holo_lbox
if strcmp(get(handles.recon_window,'SelectionType'),'open')
    prev_button_Callback(handles.prev_button, [], handles)
end


% --- Executes during object creation, after setting all properties.
function setdistx_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setdistx_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function setdistx_edit_Callback(hObject, eventdata, handles)
% hObject    handle to setdistx_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of setdistx_edit as text
%        str2double(get(hObject,'String')) returns contents of setdistx_edit as a double
temp=str2num(get(hObject,'string'));
if ~isempty(temp) && isequal(size(temp),[1,1])
    handles.reconps.dist(1)=temp;
    handles.distxok=1;
    set(handles.dx2_edit2,'enable','on')
    set(handles.dx2_edit3,'enable','on')
    set(handles.N2_edit,'enable','on')
    set(handles.regionx_edit,'enable','on')
    set(handles.dy2e2dx2,'value',get(handles.dy2e2dx2,'min'))
    set(handles.dx2e2dy2,'value',get(handles.dx2e2dy2,'min'))
    if handles.distyok
        set(handles.dy2e2dx2,'enable','on')
        set(handles.dx2e2dy2,'enable','on')
        set(handles.singlefft_toggle,'value',get(handles.singlefft_toggle,'min'))
        set(handles.singlefft_toggle,'enable','on')
    end
else
    if handles.distxok
        set(hObject,'string',num2str(handles.reconps.dist(1)))
    else
        set(hObject,'string','')
    end
    return
end

handles.reconps.b=[1,1];
handles.reconps.MN2=[handles.hwp.M,handles.hwp.N];
handles.reconps.center=[0,0];
handles.reconps.dxy2o(1)=handles.hwp.lambda.*1e-6.*handles.reconps.dist(1)./handles.hwp.dx./handles.hwp.N;
handles.reconps.dxy2(1)=handles.reconps.dxy2o(1)./handles.reconps.b(1);

left=handles.reconps.center(1)-handles.reconps.MN2(2)./2.*handles.reconps.dxy2(1);
right=handles.reconps.center(1)+(handles.reconps.MN2(2)./2-1).*handles.reconps.dxy2(1);

set(handles.dx2_edit1,'string',num2str(handles.reconps.dxy2o(1)));
set(handles.dx2_edit2,'string',num2str(handles.reconps.b(1)));
set(handles.dx2_edit3,'string',num2str(handles.reconps.dxy2(1)));
set(handles.N2_edit,'string',num2str(handles.reconps.MN2(2)));
set(handles.regionx_edit,'string',['[',num2str(left),',',num2str(right),']']);

if handles.distyok
    handles.reconps.dxy2o(2)=handles.hwp.lambda.*1e-6.*handles.reconps.dist(2)./handles.hwp.dy./handles.hwp.M;
    handles.reconps.dxy2(2)=handles.reconps.dxy2o(2)./handles.reconps.b(2);
    
    down=handles.reconps.center(2)-handles.reconps.MN2(1)./2.*handles.reconps.dxy2(2);
    up=handles.reconps.center(2)+(handles.reconps.MN2(1)./2-1).*handles.reconps.dxy2(2);
    
    set(handles.dy2_edit1,'string',num2str(handles.reconps.dxy2(2)));
    set(handles.dy2_edit2,'string',num2str(handles.reconps.b(2)));
    set(handles.dy2_edit3,'string',num2str(handles.reconps.dxy2(2)));
    set(handles.M2_edit,'string',num2str(handles.reconps.MN2(1)));
    set(handles.regiony_edit,'string',['[',num2str(down),',',num2str(up),']']);
end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function setdisty_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setdisty_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function setdisty_edit_Callback(hObject, eventdata, handles)
% hObject    handle to setdisty_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of setdisty_edit as text
%        str2double(get(hObject,'String')) returns contents of setdisty_edit as a double
temp=str2num(get(hObject,'string'));
if ~isempty(temp) && isequal(size(temp),[1,1])
    handles.reconps.dist(2)=temp;
    handles.distyok=1;
    set(handles.dy2_edit2,'enable','on')
    set(handles.dy2_edit3,'enable','on')
    set(handles.M2_edit,'enable','on')
    set(handles.regiony_edit,'enable','on')
    set(handles.dy2e2dx2,'value',get(handles.dy2e2dx2,'min'))
    set(handles.dx2e2dy2,'value',get(handles.dx2e2dy2,'min'))
    if handles.distxok
        set(handles.dy2e2dx2,'enable','on')
        set(handles.dx2e2dy2,'enable','on')
        set(handles.singlefft_toggle,'value',get(handles.singlefft_toggle,'min'))
        set(handles.singlefft_toggle,'enable','on')
    end
else
    if handles.distyok
        set(hObject,'string',num2str(handles.reconps.dist(2)))
    else
        set(hObject,'string','')
    end
    return
end

handles.reconps.b=[1,1];
handles.reconps.MN2=[handles.hwp.M,handles.hwp.N];
handles.reconps.center=[0,0];
handles.reconps.dxy2o(2)=handles.hwp.lambda.*1e-6.*handles.reconps.dist(2)./handles.hwp.dy./handles.hwp.M;
handles.reconps.dxy2(2)=handles.reconps.dxy2o(2)./handles.reconps.b(2);

down=handles.reconps.center(2)-handles.reconps.MN2(1)./2.*handles.reconps.dxy2(2);
up=handles.reconps.center(2)+(handles.reconps.MN2(1)./2-1).*handles.reconps.dxy2(2);

set(handles.dy2_edit1,'string',num2str(handles.reconps.dxy2(2)));
set(handles.dy2_edit2,'string',num2str(handles.reconps.b(2)));
set(handles.dy2_edit3,'string',num2str(handles.reconps.dxy2(2)));
set(handles.M2_edit,'string',num2str(handles.reconps.MN2(1)));
set(handles.regiony_edit,'string',['[',num2str(down),',',num2str(up),']']);

if handles.distxok
    handles.reconps.dxy2o(1)=handles.hwp.lambda.*1e-6.*handles.reconps.dist(1)./handles.hwp.dx./handles.hwp.N;
    handles.reconps.dxy2(1)=handles.reconps.dxy2o(1)./handles.reconps.b(1);
    
    left=handles.reconps.center(1)-handles.reconps.MN2(2)./2.*handles.reconps.dxy2(1);
    right=handles.reconps.center(1)+(handles.reconps.MN2(2)./2-1).*handles.reconps.dxy2(1);
    
    set(handles.dx2_edit1,'string',num2str(handles.reconps.dxy2o(1)));
    set(handles.dx2_edit2,'string',num2str(handles.reconps.b(1)));
    set(handles.dx2_edit3,'string',num2str(handles.reconps.dxy2(1)));
    set(handles.N2_edit,'string',num2str(handles.reconps.MN2(2)));
    set(handles.regionx_edit,'string',['[',num2str(left),',',num2str(right),']']);
end

guidata(hObject,handles)


% --- Executes on button press in setregion_button.
function setregion_button_Callback(hObject, eventdata, handles)
% hObject    handle to setregion_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.ondisp.im)
    return
end

axes(handles.prev_axes)
[x,y] = ginput(2);
if isempty(x) || isempty(y)
    return
end
x=sort(x);
y=sort(y);

set(handles.regionx_edit,'string',['[',num2str(x(1)),',',num2str(x(2)),']']);
set(handles.regiony_edit,'string',['[',num2str(y(1)),',',num2str(y(2)),']']);
regionx_edit_Callback(handles.regionx_edit, [], handles);
handles=guidata(hObject);
regiony_edit_Callback(handles.regiony_edit, [], handles);


% --- Executes on button press in prev_button.
function prev_button_Callback(hObject, eventdata, handles)
% hObject    handle to prev_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.holo_lbox,'string');
index=get(handles.holo_lbox,'value');
if isempty(items) || length(index)>1 ||...
        isempty(handles.reconps.dist) || length(handles.reconps.dist)<2 ||...
        prod(handles.reconps.dist)==0
    return
end

if get(handles.singlefft_toggle,'value')==get(handles.singlefft_toggle,'max')
    if get(handles.rot_check,'value')==get(handles.rot_check,'max')
        handles.ondisp.im=zero2one(abs(fresnel(rot90(handles.holograms.(items{index}),2),...
            -handles.reconps.dist,[handles.hwp.dx,handles.hwp.dy],handles.hwp.lambda.*1e-6)));
    else
        handles.ondisp.im=zero2one(abs(fresnel(handles.holograms.(items{index}),...
            -handles.reconps.dist,[handles.hwp.dx,handles.hwp.dy],handles.hwp.lambda.*1e-6)));
    end
else
    if get(handles.rot_check,'value')==get(handles.rot_check,'max')
        handles.ondisp.im=zero2one(abs(FDADS(rot90(handles.holograms.(items{index}),2),...
            -handles.reconps.dist,[handles.hwp.dx,handles.hwp.dy],...
            handles.reconps.b,handles.reconps.MN2,handles.reconps.center,...
            handles.hwp.lambda.*1e-6)));
    else
        handles.ondisp.im=zero2one(abs(FDADS(handles.holograms.(items{index}),...
            -handles.reconps.dist,[handles.hwp.dx,handles.hwp.dy],...
            handles.reconps.b,handles.reconps.MN2,handles.reconps.center,...
            handles.hwp.lambda.*1e-6)));
    end
end

handles.ondisp.dxy2=handles.reconps.dxy2;
handles.ondisp.center=handles.reconps.center;
v=get(handles.slider,'value');
axes(handles.prev_axes);
opticimage((handles.ondisp.im).^v,handles.ondisp.dxy2(1),handles.ondisp.dxy2(2),handles.ondisp.center);

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
if isempty(handles.ondisp.im)
    return
end
v=get(handles.slider,'value');
axes(handles.prev_axes);
opticimage((handles.ondisp.im).^v,handles.ondisp.dxy2(1),handles.ondisp.dxy2(2),handles.ondisp.center);


% --- Executes during object creation, after setting all properties.
function dx_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dx_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dx_edit_Callback(hObject, eventdata, handles)
% hObject    handle to dx_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dx_edit as text
%        str2double(get(hObject,'String')) returns contents of dx_edit as a double
handles.hwp.dx=str2num(get(hObject,'string'));
guidata(hObject,handles)

if handles.distxok
    handles.reconps.dxy2o(1)=handles.hwp.lambda.*1e-6.*handles.reconps.dist(1)./...
        handles.hwp.dx./handles.hwp.N;
    handles.reconps.dxy2(1)=handles.reconps.dxy2o(1)./handles.reconps.b(1);
    
    regionx=str2num(get(handles.regionx_edit,'string'));
    left=min(regionx);
    right=max(regionx);
    handles.reconps.MN2(2)=round(round((right-left)./handles.reconps.dxy2(1)+1)./2).*2;
    
    set(handles.dx2_edit1,'string',num2str(handles.reconps.dxy2o(1)));
    set(handles.dx2_edit3,'string',num2str(handles.reconps.dxy2(1)));
    set(handles.N2_edit,'string',num2str(handles.reconps.MN2(2)));
end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function dy_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dy_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dy_edit_Callback(hObject, eventdata, handles)
% hObject    handle to dy_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dy_edit as text
%        str2double(get(hObject,'String')) returns contents of dy_edit as a double
handles.hwp.dy=str2num(get(hObject,'string'));
guidata(hObject,handles)

if handles.distyok
    handles.reconps.dxy2o(2)=handles.hwp.lambda.*1e-6.*handles.reconps.dist(2)./...
        handles.hwp.dy./handles.hwp.M;
    handles.reconps.dxy2(2)=handles.reconps.dxy2o(2)./handles.reconps.b(2);
    
    regiony=str2num(get(handles.regiony_edit,'string'));
    down=min(regiony);
    up=max(regiony);
    handles.reconps.MN2(1)=round(round((up-down)./handles.reconps.dxy2(2)+1)./2).*2;
    
    set(handles.dy2_edit1,'string',num2str(handles.reconps.dxy2o(2)));
    set(handles.dy2_edit3,'string',num2str(handles.reconps.dxy2(2)));
    set(handles.M2_edit,'string',num2str(handles.reconps.MN2(1)));
end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function lambda_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lambda_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function lambda_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lambda_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lambda_edit as text
%        str2double(get(hObject,'String')) returns contents of lambda_edit as a double
handles.hwp.lambda=str2num(get(hObject,'string'));
guidata(hObject,handles)

if handles.distxok
    handles.reconps.dxy2o(1)=handles.hwp.lambda.*1e-6.*handles.reconps.dist(1)./...
        handles.hwp.dx./handles.hwp.N;
    handles.reconps.dxy2(1)=handles.reconps.dxy2o(1)./handles.reconps.b(1);
    
    regionx=str2num(get(handles.regionx_edit,'string'));
    left=min(regionx);
    right=max(regionx);
    handles.reconps.MN2(2)=round(round((right-left)./handles.reconps.dxy2(1)+1)./2).*2;
    
    set(handles.dx2_edit1,'string',num2str(handles.reconps.dxy2o(1)));
    set(handles.dx2_edit3,'string',num2str(handles.reconps.dxy2(1)));
    set(handles.N2_edit,'string',num2str(handles.reconps.MN2(2)));
end

if handles.distyok
    handles.reconps.dxy2o(2)=handles.hwp.lambda.*1e-6.*handles.reconps.dist(2)./...
        handles.hwp.dy./handles.hwp.M;
    handles.reconps.dxy2(2)=handles.reconps.dxy2o(2)./handles.reconps.b(2);
    
    regiony=str2num(get(handles.regiony_edit,'string'));
    down=min(regiony);
    up=max(regiony);
    handles.reconps.MN2(1)=round(round((up-down)./handles.reconps.dxy2(2)+1)./2).*2;
    
    set(handles.dy2_edit1,'string',num2str(handles.reconps.dxy2o(2)));
    set(handles.dy2_edit3,'string',num2str(handles.reconps.dxy2(2)));
    set(handles.M2_edit,'string',num2str(handles.reconps.MN2(1)));
end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function dx2_edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dx2_edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dx2_edit1_Callback(hObject, eventdata, handles)
% hObject    handle to dx2_edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dx2_edit1 as text
%        str2double(get(hObject,'String')) returns contents of dx2_edit1 as a double


% --- Executes during object creation, after setting all properties.
function dy2_edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dy2_edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dy2_edit1_Callback(hObject, eventdata, handles)
% hObject    handle to dy2_edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dy2_edit1 as text
%        str2double(get(hObject,'String')) returns contents of dy2_edit1 as a double


% --- Executes during object creation, after setting all properties.
function dx2_edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dx2_edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dx2_edit2_Callback(hObject, eventdata, handles)
% hObject    handle to dx2_edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dx2_edit2 as text
%        str2double(get(hObject,'String')) returns contents of dx2_edit2 as a double
handles.reconps.b(1)=str2num(get(hObject,'string'));
if isempty(handles.reconps.dxy2o)
    return
end
regionx=str2num(get(handles.regionx_edit,'string'));
left=min(regionx);
right=max(regionx);

handles.reconps.dxy2(1)=handles.reconps.dxy2o(1)./handles.reconps.b(1);
handles.reconps.MN2(2)=round(round((right-left)./handles.reconps.dxy2(1)+1)./2).*2;
set(handles.dx2_edit3,'string',num2str(handles.reconps.dxy2(1)))
set(handles.N2_edit,'string',num2str(handles.reconps.MN2(2)))

if get(handles.dy2e2dx2,'value')==get(handles.dy2e2dx2,'max')
    handles.reconps.dxy2(2)=handles.reconps.dxy2(1);
    handles.reconps.b(2)=handles.reconps.dxy2o(2)./handles.reconps.dxy2(2);
    regiony=str2num(get(handles.regiony_edit,'string'));
    down=min(regiony);
    up=max(regiony);
    handles.reconps.MN2(1)=round(round((up-down)./handles.reconps.dxy2(2)+1)./2).*2;
    set(handles.dy2_edit3,'string',num2str(handles.reconps.dxy2(2)))
    set(handles.dy2_edit2,'string',num2str(handles.reconps.b(2)))
    set(handles.M2_edit,'string',num2str(handles.reconps.MN2(1)))
end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function dy2_edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dy2_edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dy2_edit2_Callback(hObject, eventdata, handles)
% hObject    handle to dy2_edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dy2_edit2 as text
%        str2double(get(hObject,'String')) returns contents of dy2_edit2 as a double
handles.reconps.b(2)=str2num(get(hObject,'string'));
if isempty(handles.reconps.dxy2o)
    return
end
regiony=str2num(get(handles.regiony_edit,'string'));
down=min(regiony);
up=max(regiony);

handles.reconps.dxy2(2)=handles.reconps.dxy2o(2)./handles.reconps.b(2);
handles.reconps.MN2(1)=round(round((up-down)./handles.reconps.dxy2(2)+1)./2).*2;
set(handles.dy2_edit3,'string',num2str(handles.reconps.dxy2(2)))
set(handles.M2_edit,'string',num2str(handles.reconps.MN2(1)))

if get(handles.dx2e2dy2,'value')==get(handles.dx2e2dy2,'max')
    handles.reconps.dxy2(1)=handles.reconps.dxy2(2);
    handles.reconps.b(1)=handles.reconps.dxy2o(1)./handles.reconps.dxy2(1);
    regionx=str2num(get(handles.regionx_edit,'string'));
    left=min(regionx);
    right=max(regionx);
    handles.reconps.MN2(2)=round(round((right-left)./handles.reconps.dxy2(1)+1)./2).*2;
    set(handles.dx2_edit3,'string',num2str(handles.reconps.dxy2(1)))
    set(handles.dx2_edit2,'string',num2str(handles.reconps.b(1)))
    set(handles.N2_edit,'string',num2str(handles.reconps.MN2(2)))
end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function dx2_edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dx2_edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dx2_edit3_Callback(hObject, eventdata, handles)
% hObject    handle to dx2_edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dx2_edit3 as text
%        str2double(get(hObject,'String')) returns contents of dx2_edit3 as a double
handles.reconps.dxy2(1)=str2num(get(hObject,'string'));
if isempty(handles.reconps.dxy2o)
    return
end

regionx=str2num(get(handles.regionx_edit,'string'));
left=min(regionx);
right=max(regionx);
handles.reconps.b(1)=handles.reconps.dxy2o(1)./handles.reconps.dxy2(1);
handles.reconps.MN2(2)=round(round((right-left)./handles.reconps.dxy2(1)+1)./2).*2;
set(handles.dx2_edit2,'string',num2str(handles.reconps.b(1)))
set(handles.N2_edit,'string',num2str(handles.reconps.MN2(2)))

if get(handles.dy2e2dx2,'value')==get(handles.dy2e2dx2,'max')
    regiony=str2num(get(handles.regiony_edit,'string'));
    down=min(regiony);
    up=max(regiony);
    handles.reconps.dxy2(2)=handles.reconps.dxy2(1);
    handles.reconps.b(2)=handles.reconps.dxy2o(2)./handles.reconps.dxy2(2);
    handles.reconps.MN2(1)=round(round((up-down)./handles.reconps.dxy2(2)+1)./2).*2;
    set(handles.dy2_edit3,'string',num2str(handles.reconps.dxy2(2)))
    set(handles.dy2_edit2,'string',num2str(handles.reconps.b(2)))
    set(handles.M2_edit,'string',num2str(handles.reconps.MN2(1)))
end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function dy2_edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dy2_edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dy2_edit3_Callback(hObject, eventdata, handles)
% hObject    handle to dy2_edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dy2_edit3 as text
%        str2double(get(hObject,'String')) returns contents of dy2_edit3 as a double
handles.reconps.dxy2(2)=str2num(get(hObject,'string'));
if isempty(handles.reconps.dxy2o)
    return
end

regiony=str2num(get(handles.regiony_edit,'string'));
down=min(regiony);
up=max(regiony);
handles.reconps.b(2)=handles.reconps.dxy2o(2)./handles.reconps.dxy2(2);
handles.reconps.MN2(1)=round(round((up-down)./handles.reconps.dxy2(2)+1)./2).*2;
set(handles.dy2_edit2,'string',num2str(handles.reconps.b(2)))
set(handles.M2_edit,'string',num2str(handles.reconps.MN2(1)))

if get(handles.dx2e2dy2,'value')==get(handles.dx2e2dy2,'max')
    regionx=str2num(get(handles.regionx_edit,'string'));
    left=min(regionx);
    right=max(regionx);
    handles.reconps.dxy2(1)=handles.reconps.dxy2(2);
    handles.reconps.b(1)=handles.reconps.dxy2o(1)./handles.reconps.dxy2(1);
    handles.reconps.MN2(2)=round(round((right-left)./handles.reconps.dxy2(1)+1)./2).*2;
    set(handles.dx2_edit3,'string',num2str(handles.reconps.dxy2(1)))
    set(handles.dx2_edit2,'string',num2str(handles.reconps.b(1)))
    set(handles.N2_edit,'string',num2str(handles.reconps.MN2(2)))
end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function N2_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to N2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function N2_edit_Callback(hObject, eventdata, handles)
% hObject    handle to N2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of N2_edit as text
%        str2double(get(hObject,'String')) returns contents of N2_edit as a double
handles.reconps.MN2(2)=round(str2num(get(hObject,'string'))./2).*2;
set(hObject,'string',num2str(handles.reconps.MN2(2)))
if isempty(handles.reconps.dxy2o)
    return
end

regionx=str2num(get(handles.regionx_edit,'string'));
left=min(regionx);
right=max(regionx);
handles.reconps.dxy2(1)=(right-left)./(handles.reconps.MN2(2)-1);
handles.reconps.b(1)=handles.reconps.dxy2o(1)./handles.reconps.dxy2(1);
set(handles.dx2_edit2,'string',num2str(handles.reconps.b(1)))
set(handles.dx2_edit3,'string',num2str(handles.reconps.dxy2(1)))

if get(handles.dy2e2dx2,'value')==get(handles.dy2e2dx2,'max')
    handles.reconps.dxy2(2)=handles.reconps.dxy2(1);
    handles.reconps.b(2)=handles.reconps.dxy2o(2)./handles.reconps.dxy2(2);
    regiony=str2num(get(handles.regiony_edit,'string'));
    down=min(regiony);
    up=max(regiony);
    handles.reconps.MN2(1)=round(round((up-down)./handles.reconps.dxy2(2)+1)./2).*2;
    set(handles.dy2_edit3,'string',num2str(handles.reconps.dxy2(2)))
    set(handles.dy2_edit2,'string',num2str(handles.reconps.b(2)))
    set(handles.M2_edit,'string',num2str(handles.reconps.MN2(1)))
end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function M2_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to M2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function M2_edit_Callback(hObject, eventdata, handles)
% hObject    handle to M2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of M2_edit as text
%        str2double(get(hObject,'String')) returns contents of M2_edit as a double
handles.reconps.MN2(1)=round(str2num(get(hObject,'string'))./2).*2;
set(hObject,'string',num2str(handles.reconps.MN2(1)))
if isempty(handles.reconps.dxy2o)
    return
end

regiony=str2num(get(handles.regiony_edit,'string'));
down=min(regiony);
up=max(regiony);
handles.reconps.dxy2(2)=(up-down)./(handles.reconps.MN2(1)-1);
handles.reconps.b(2)=handles.reconps.dxy2o(2)./handles.reconps.dxy2(2);
set(handles.dy2_edit2,'string',num2str(handles.reconps.b(2)))
set(handles.dy2_edit3,'string',num2str(handles.reconps.dxy2(2)))

if get(handles.dx2e2dy2,'value')==get(handles.dx2e2dy2,'max')
    regionx=str2num(get(handles.regionx_edit,'string'));
    left=min(regionx);
    right=max(regionx);
    handles.reconps.dxy2(1)=handles.reconps.dxy2(2);
    handles.reconps.b(1)=handles.reconps.dxy2o(1)./handles.reconps.dxy2(1);
    handles.reconps.MN2(2)=round(round((right-left)./handles.reconps.dxy2(1)+1)./2).*2;
    set(handles.dx2_edit3,'string',num2str(handles.reconps.dxy2(1)))
    set(handles.dx2_edit2,'string',num2str(handles.reconps.b(1)))
    set(handles.N2_edit,'string',num2str(handles.reconps.MN2(2)))
end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function regionx_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to regionx_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function regionx_edit_Callback(hObject, eventdata, handles)
% hObject    handle to regionx_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of regionx_edit as text
%        str2double(get(hObject,'String')) returns contents of regionx_edit as a double
if ~isempty(handles.reconps.dxy2o)
    regionx=str2num(get(handles.regionx_edit,'string'));
    left=min(regionx);
    right=max(regionx);
    handles.reconps.center(1)=(left+right)./2;
    handles.reconps.MN2(2)=round(round((right-left)./handles.reconps.dxy2(1)+1)./2).*2;
    set(handles.N2_edit,'string',num2str(handles.reconps.MN2(2)))
end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function regiony_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to regiony_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function regiony_edit_Callback(hObject, eventdata, handles)
% hObject    handle to regiony_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of regiony_edit as text
%        str2double(get(hObject,'String')) returns contents of regiony_edit as a double
if ~isempty(handles.reconps.dxy2o)
    regiony=str2num(get(handles.regiony_edit,'string'));
    down=min(regiony);
    up=max(regiony);
    handles.reconps.center(2)=(up+down)./2;
    handles.reconps.MN2(1)=round(round((up-down)./handles.reconps.dxy2(2)+1)./2).*2;
    set(handles.M2_edit,'string',num2str(handles.reconps.MN2(1)))
end

guidata(hObject,handles)


% --- Executes on button press in selected_radio.
function selected_radio_Callback(hObject, eventdata, handles)
% hObject    handle to selected_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of selected_radio
v=get(handles.all_radio,'value');
vmax=get(handles.all_radio,'Max');
vmin=get(handles.all_radio,'Min');
set(handles.all_radio,'value',vmax+vmin-v)


% --- Executes on button press in all_radio.
function all_radio_Callback(hObject, eventdata, handles)
% hObject    handle to all_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of all_radio
v=get(handles.selected_radio,'value');
vmax=get(handles.selected_radio,'Max');
vmin=get(handles.selected_radio,'Min');
set(handles.selected_radio,'value',vmax+vmin-v)


% --- Executes on button press in recon_button.
function recon_button_Callback(hObject, eventdata, handles)
% hObject    handle to recon_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.holo_lbox,'string');
index=get(handles.holo_lbox,'value');
if isempty(items) || isempty(handles.reconps.dist) || length(handles.reconps.dist)<2
    return
end

if get(handles.selected_radio,'value')==get(handles.all_radio,'max')
    items=items(index);
end

N=length(items);
h=waitbar(0,'Calculating...');

if prod(handles.reconps.dist)==0
    for n=1:N
        if get(handles.rot_check,'value')==get(handles.rot_check,'max')
            handles.recons(1).([handles.prefix,items{n}])=rot90(handles.holograms.(items{n}),2);
        else
            handles.recons(1).([handles.prefix,items{n}])=handles.holograms.(items{n});
        end
        handles.recons(2).([handles.prefix,items{n}]).dist=[0,0];
        handles.recons(2).([handles.prefix,items{n}]).b=[NaN,NaN];
        handles.recons(2).([handles.prefix,items{n}]).MN2=size(handles.holograms.(items{n}));
        handles.recons(2).([handles.prefix,items{n}]).center=[0,0];
        handles.recons(2).([handles.prefix,items{n}]).dxy2o=[0,0];
        handles.recons(2).([handles.prefix,items{n}]).dxy2=[handles.hwp.dx,handles.hwp.dy];
        waitbar(n/N,h);
    end
else
    if get(handles.singlefft_toggle,'value')==get(handles.singlefft_toggle,'max')
        for n=1:N
            if get(handles.rot_check,'value')==get(handles.rot_check,'max')
                handles.recons(1).([handles.prefix,items{n}])=fresnel(rot90(handles.holograms.(items{n}),2),...
                    -handles.reconps.dist,[handles.hwp.dx,handles.hwp.dy],handles.hwp.lambda.*1e-6);
            else
                handles.recons(1).([handles.prefix,items{n}])=fresnel(handles.holograms.(items{n}),...
                    -handles.reconps.dist,[handles.hwp.dx,handles.hwp.dy],handles.hwp.lambda.*1e-6);
            end
            handles.recons(2).([handles.prefix,items{n}])=handles.reconps;
            waitbar(n/N,h);
        end
    else
        for n=1:N
            if get(handles.rot_check,'value')==get(handles.rot_check,'max')
                handles.recons(1).([handles.prefix,items{n}])=FDADS(rot90(handles.holograms.(items{n}),2),...
                    -handles.reconps.dist,[handles.hwp.dx,handles.hwp.dy],...
                    handles.reconps.b,handles.reconps.MN2,handles.reconps.center,...
                    handles.hwp.lambda.*1e-6);
            else
                handles.recons(1).([handles.prefix,items{n}])=FDADS(handles.holograms.(items{n}),...
                    -handles.reconps.dist,[handles.hwp.dx,handles.hwp.dy],...
                    handles.reconps.b,handles.reconps.MN2,handles.reconps.center,...
                    handles.hwp.lambda.*1e-6);
            end
            handles.recons(2).([handles.prefix,items{n}])=handles.reconps;
            waitbar(n/N,h);
        end
    end
end

close(h);

guidata(hObject,handles)

if isequal(get(handles.recon_window, 'waitstatus'), 'waiting')
    set(handles.recon_button,'enable','off')
    uiresume(handles.recon_window);
end


% --- Executes on button press in dy2e2dx2.
function dy2e2dx2_Callback(hObject, eventdata, handles)
% hObject    handle to dy2e2dx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dy2e2dx2
if get(hObject,'value')==get(hObject,'max')
    set(handles.dx2e2dy2,'value',get(handles.dx2e2dy2,'min'))
    set(handles.dy2_edit2,'enable','inactive')
    set(handles.dy2_edit3,'enable','inactive')
    set(handles.M2_edit,'enable','inactive')
    set(handles.dx2_edit2,'enable','on')
    set(handles.dx2_edit3,'enable','on')
    set(handles.N2_edit,'enable','on')
else
    set(handles.dy2_edit2,'enable','on')
    set(handles.dy2_edit3,'enable','on')
    set(handles.M2_edit,'enable','on')
    return
end
if ~isempty(handles.reconps.dxy2o)
    regiony=str2num(get(handles.regiony_edit,'string'));
    down=min(regiony);
    up=max(regiony);
    handles.reconps.dxy2(2)=handles.reconps.dxy2(1);
    handles.reconps.b(2)=handles.reconps.dxy2o(2)./handles.reconps.dxy2(2);
    handles.reconps.MN2(1)=round(round((up-down)./handles.reconps.dxy2(2)+1)./2).*2;
    set(handles.dy2_edit3,'string',num2str(handles.reconps.dxy2(2)))
    set(handles.dy2_edit2,'string',num2str(handles.reconps.b(2)))
    set(handles.M2_edit,'string',num2str(handles.reconps.MN2(1)))
end

guidata(hObject,handles)


% --- Executes on button press in dx2e2dy2.
function dx2e2dy2_Callback(hObject, eventdata, handles)
% hObject    handle to dx2e2dy2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dx2e2dy2
if get(hObject,'value')==get(hObject,'max')
    set(handles.dy2e2dx2,'value',get(handles.dy2e2dx2,'min'))
    set(handles.dx2_edit2,'enable','inactive')
    set(handles.dx2_edit3,'enable','inactive')
    set(handles.N2_edit,'enable','inactive')
    set(handles.dy2_edit2,'enable','on')
    set(handles.dy2_edit3,'enable','on')
    set(handles.M2_edit,'enable','on')
else
    set(handles.dx2_edit2,'enable','on')
    set(handles.dx2_edit3,'enable','on')
    set(handles.N2_edit,'enable','on')
    return
end
if ~isempty(handles.reconps.dxy2o)
    regionx=str2num(get(handles.regionx_edit,'string'));
    left=min(regionx);
    right=max(regionx);
    handles.reconps.dxy2(1)=handles.reconps.dxy2(2);
    handles.reconps.b(1)=handles.reconps.dxy2o(1)./handles.reconps.dxy2(1);
    handles.reconps.MN2(2)=round(round((right-left)./handles.reconps.dxy2(1)+1)./2).*2;
    set(handles.dx2_edit3,'string',num2str(handles.reconps.dxy2(1)))
    set(handles.dx2_edit2,'string',num2str(handles.reconps.b(1)))
    set(handles.N2_edit,'string',num2str(handles.reconps.MN2(2)))
end

guidata(hObject,handles)


% --- Executes on button press in singlefft_toggle.
function singlefft_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to singlefft_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of singlefft_toggle
if get(hObject,'value')==get(hObject,'max')
    handles.reconps.b=[1,1];
    handles.reconps.MN2=[handles.hwp.M,handles.hwp.N];
    handles.reconps.center=[0,0];
    set(handles.dx2_edit2,'string',num2str(handles.reconps.b(1)));
    set(handles.dy2_edit2,'string',num2str(handles.reconps.b(2)));
    set(handles.N2_edit,'string',num2str(handles.reconps.MN2(2))); % <==
    set(handles.M2_edit,'string',num2str(handles.reconps.MN2(1))); % <==
    if ~isempty(handles.reconps.dist)
        handles.reconps.dxy2o=[handles.hwp.lambda.*1e-6.*handles.reconps.dist(1)./handles.hwp.dx./handles.hwp.N,...
                handles.hwp.lambda.*1e-6.*handles.reconps.dist(2)./handles.hwp.dy./handles.hwp.M];
        handles.reconps.dxy2=handles.reconps.dxy2o./handles.reconps.b;
        set(handles.dx2_edit1,'string',num2str(handles.reconps.dxy2o(1)));
        set(handles.dy2_edit1,'string',num2str(handles.reconps.dxy2o(2)));
        set(handles.dx2_edit3,'string',num2str(handles.reconps.dxy2(1)));
        set(handles.dy2_edit3,'string',num2str(handles.reconps.dxy2(2)));
        
        left=handles.reconps.center(1)-handles.reconps.MN2(2)./2.*handles.reconps.dxy2(1);
        right=handles.reconps.center(1)+(handles.reconps.MN2(2)./2-1).*handles.reconps.dxy2(1);
        down=handles.reconps.center(2)-handles.reconps.MN2(1)./2.*handles.reconps.dxy2(2);
        up=handles.reconps.center(2)+(handles.reconps.MN2(1)./2-1).*handles.reconps.dxy2(2);
        set(handles.regionx_edit,'string',['[',num2str(left),',',num2str(right),']']);
        set(handles.regiony_edit,'string',['[',num2str(down),',',num2str(up),']']);
    end
    set(handles.dx2_edit2,'enable','inactive');
    set(handles.dy2_edit2,'enable','inactive');
    set(handles.dx2_edit3,'enable','inactive');
    set(handles.dy2_edit3,'enable','inactive');
    set(handles.N2_edit,'enable','inactive');
    set(handles.M2_edit,'enable','inactive');
    set(handles.regionx_edit,'enable','inactive');
    set(handles.regiony_edit,'enable','inactive');
    set(handles.dy2e2dx2,'value',get(handles.dy2e2dx2,'min'),'enable','off');
    set(handles.dx2e2dy2,'value',get(handles.dx2e2dy2,'min'),'enable','off');
    set(handles.setregion_button,'enable','off');
else
    set(handles.dx2_edit2,'enable','on');
    set(handles.dy2_edit2,'enable','on');
    set(handles.dx2_edit3,'enable','on');
    set(handles.dy2_edit3,'enable','on');
    set(handles.N2_edit,'enable','on');
    set(handles.M2_edit,'enable','on');
    set(handles.regionx_edit,'enable','on');
    set(handles.regiony_edit,'enable','on');
    set(handles.dy2e2dx2,'enable','on');
    set(handles.dx2e2dy2,'enable','on');
    set(handles.setregion_button,'enable','on');
end

guidata(hObject,handles)


% --- Executes when user attempts to close recon_window.
function recon_window_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to recon_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(handles.recon_window, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(handles.recon_window);
else
    % The GUI is no longer waiting, just close it
    delete(handles.recon_window);
end


% --- Executes during object creation, after setting all properties.
function prefix_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prefix_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function prefix_edit_Callback(hObject, eventdata, handles)
% hObject    handle to prefix_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prefix_edit as text
%        str2double(get(hObject,'String')) returns contents of prefix_edit as a double
prefix=get(handles.prefix_edit,'string');
if isvarname(prefix)
    handles.prefix=prefix;
    guidata(hObject,handles)
else
    set(handles.prefix_edit,'string',handles.prefix)
end


% --- Executes on button press in rot_check.
function rot_check_Callback(hObject, eventdata, handles)
% hObject    handle to rot_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rot_check


