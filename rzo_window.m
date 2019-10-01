function varargout = rzo_window(varargin)
% RZO_WINDOW M-file for rzo_window.fig
%      RZO_WINDOW, by itself, creates a new RZO_WINDOW or raises the existing
%      singleton*.
%
%      H = RZO_WINDOW returns the handle to a new RZO_WINDOW or the handle to
%      the existing singleton*.
%
%      RZO_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RZO_WINDOW.M with the given input arguments.
%
%      RZO_WINDOW('Property','Value',...) creates a new RZO_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rzo_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rzo_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rzo_window

% Last Modified by GUIDE v2.5 31-Jul-2007 17:35:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rzo_window_OpeningFcn, ...
                   'gui_OutputFcn',  @rzo_window_OutputFcn, ...
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


% --- Executes just before rzo_window is made visible.
function rzo_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rzo_window (see VARARGIN)
handles.holograms=[];
handles.objs=[];
handles.refs=[];
handles.background=[];
handles.readdir='C:\';

set(handles.holo_lbox,'String',cell(1,0),'value',1);
set(handles.obj_lbox,'String',cell(1,0),'value',1);
set(handles.ref_lbox,'String',cell(1,0),'value',1);
if nargin > 4
    for n=1:2:length(varargin)
        if strcmpi(varargin{n},'readdir')
            if exist(varargin{n+1})==7
                handles.readdir = varargin{n+1};
            end
        end
        if strcmpi(varargin{n},'holograms')
            handles.holograms=varargin{n+1};
            if ~isempty(handles.holograms)
                set(handles.holo_lbox,'string',sort(fieldnames(handles.holograms)))
            end
        end
    end
end

% Choose default command line output for rzo_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rzo_window wait for user response (see UIRESUME)
uiwait(handles.rzo_window);


% --- Outputs from this function are returned to the command line.
function varargout = rzo_window_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if strcmp(get(handles.done,'enable'),'off')
    varargout{1} = handles.holograms;
else
    varargout{1} = [];
end
delete(handles.rzo_window)


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


% --- Executes on button press in holo_up.
function holo_up_Callback(hObject, eventdata, handles)
% hObject    handle to holo_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.holo_lbox,'string');
index=get(handles.holo_lbox,'value');
if isempty(items) || length(items)==1 || (max(index)-min(index)+1)>length(index)
    return
end

if min(index)>1
    temp=items(min(index)-1);
    items(index-1)=items(index);
    items(max(index))=temp;
    set(handles.holo_lbox,'string',items);
    set(handles.holo_lbox,'value',index-1);
end


% --- Executes on button press in holo_down.
function holo_down_Callback(hObject, eventdata, handles)
% hObject    handle to holo_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.holo_lbox,'string');
index=get(handles.holo_lbox,'value');
if isempty(items) || length(items)==1 || (max(index)-min(index)+1)>length(index)
    return
end

if max(index)<length(items)
    temp=items(max(index)+1);
    items(index+1)=items(index);
    items(min(index))=temp;
    set(handles.holo_lbox,'string',items);
    set(handles.holo_lbox,'value',index+1);
end


% --- Executes on button press in holo_del.
function holo_del_Callback(hObject, eventdata, handles)
% hObject    handle to holo_del (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.holo_lbox,'string');
if isempty(items)
    return
end
index=get(handles.holo_lbox,'value');

%handles.holograms=rmfield(handles.holograms,items(index));
items(index)=[];
set(handles.holo_lbox,'value',1);
set(handles.holo_lbox,'string',items);

guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function obj_lbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to obj_lbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in obj_lbox.
function obj_lbox_Callback(hObject, eventdata, handles)
% hObject    handle to obj_lbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns obj_lbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from obj_lbox


% --- Executes on button press in obj_up.
function obj_up_Callback(hObject, eventdata, handles)
% hObject    handle to obj_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.obj_lbox,'string');
index=get(handles.obj_lbox,'value');
if isempty(items) || length(items)==1 || (max(index)-min(index)+1)>length(index)
    return
end

if min(index)>1
    temp=items(min(index)-1);
    items(index-1)=items(index);
    items(max(index))=temp;
    set(handles.obj_lbox,'string',items);
    set(handles.obj_lbox,'value',index-1);
end


% --- Executes on button press in obj_down.
function obj_down_Callback(hObject, eventdata, handles)
% hObject    handle to obj_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.obj_lbox,'string');
index=get(handles.obj_lbox,'value');
if isempty(items) || length(items)==1 || (max(index)-min(index)+1)>length(index)
    return
end

if max(index)<length(items)
    temp=items(max(index)+1);
    items(index+1)=items(index);
    items(min(index))=temp;
    set(handles.obj_lbox,'string',items);
    set(handles.obj_lbox,'value',index+1);
end


% --- Executes on button press in obj_del.
function obj_del_Callback(hObject, eventdata, handles)
% hObject    handle to obj_del (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.obj_lbox,'string');
if isempty(items)
    return
end
index=get(handles.obj_lbox,'value');
todelete=items(index);
items(index)=[];

for n=1:length(index)
    if ~sum(strcmp(todelete(n),items)) && isfield(handles.objs,todelete(n))
        handles.objs=rmfield(handles.objs,todelete(n));
    end
end

set(handles.obj_lbox,'value',1);
set(handles.obj_lbox,'string',items);

guidata(hObject,handles)


% --- Executes on button press in obj_sr.
function obj_sr_Callback(hObject, eventdata, handles)
% hObject    handle to obj_sr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
l=length(get(handles.holo_lbox,'string'));
items=get(handles.obj_lbox,'string');
index=get(handles.obj_lbox,'value');
if isempty(items) || (max(index)-min(index)+1)>length(index)
    return
end
m=length(items);
n=length(index);

switch get(handles.objfill_check,'value')
    case get(handles.objfill_check,'min')
        items(min(index)+n:m+n)=items(min(index):m);
        set(handles.obj_lbox,'string',items)
    case get(handles.objfill_check,'max')
        while length(items)+length(index)<=l
            items(min(index)+n:m+n)=items(min(index):m);
            m=length(items);
        end
        set(handles.obj_lbox,'string',items)
end


% --- Executes on button press in obj_read.
function obj_read_Callback(hObject, eventdata, handles)
% hObject    handle to obj_read (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imagefile=ri_window('dir',handles.readdir);

fnerr=0;
k=1;
filename=cell(length(imagefile),1);
for n=1:length(imagefile)
    [pathstr,name,ext,versn] = fileparts(imagefile{n});
    name(name=='-')='_';
    if ~(double(name(1))>97 && double(name(1))<122) && ~(double(name(1))>65 && double(name(1))<90)
        name=['obj',name];
    end
    if isvarname(name)
        filename{k}=name;
        k=k+1;
        imagedata=double(imread(imagefile{n}))/255;
        if size(imagedata,3)==3
            imagedata=(imagedata(:,:,1)+imagedata(:,:,2)+imagedata(:,:,3))./3;
        elseif size(imagedata,3)~=1
            imagedata=imagedata(:,:,1);
        end
        handles.objs.(name)=imagedata;
    else
        fnerr=1;
    end
end
if fnerr
    warndlg('The name of the image file is not correct, please rename the image file','Read Image Warning')
end
if ~isempty(n)
    handles.readdir=pathstr;
    if k>1
        set(handles.obj_lbox,'string',sort(fieldnames(handles.objs)))
    end
end
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function ref_lbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ref_lbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ref_lbox.
function ref_lbox_Callback(hObject, eventdata, handles)
% hObject    handle to ref_lbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ref_lbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ref_lbox


% --- Executes on button press in ref_up.
function ref_up_Callback(hObject, eventdata, handles)
% hObject    handle to ref_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.ref_lbox,'string');
index=get(handles.ref_lbox,'value');
if isempty(items) || length(items)==1 || (max(index)-min(index)+1)>length(index)
    return
end

if min(index)>1
    temp=items(min(index)-1);
    items(index-1)=items(index);
    items(max(index))=temp;
    set(handles.ref_lbox,'string',items);
    set(handles.ref_lbox,'value',index-1);
end


% --- Executes on button press in ref_down.
function ref_down_Callback(hObject, eventdata, handles)
% hObject    handle to ref_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.ref_lbox,'string');
index=get(handles.ref_lbox,'value');
if isempty(items) || length(items)==1 || (max(index)-min(index)+1)>length(index)
    return
end

if max(index)<length(items)
    temp=items(max(index)+1);
    items(index+1)=items(index);
    items(min(index))=temp;
    set(handles.ref_lbox,'string',items);
    set(handles.ref_lbox,'value',index+1);
end


% --- Executes on button press in ref_del.
function ref_del_Callback(hObject, eventdata, handles)
% hObject    handle to ref_del (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.ref_lbox,'string');
if isempty(items)
    return
end
index=get(handles.ref_lbox,'value');
todelete=items(index);
items(index)=[];

for n=1:length(index)
    if ~sum(strcmp(todelete(n),items)) && isfield(handles.refs,todelete(n))
        handles.refs=rmfield(handles.refs,todelete(n));
    end
end

set(handles.ref_lbox,'value',1);
set(handles.ref_lbox,'string',items);

guidata(hObject,handles)


% --- Executes on button press in ref_sr.
function ref_sr_Callback(hObject, eventdata, handles)
% hObject    handle to ref_sr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
l=length(get(handles.holo_lbox,'string'));
items=get(handles.ref_lbox,'string');
index=get(handles.ref_lbox,'value');
if isempty(items) || (max(index)-min(index)+1)>length(index)
    return
end
m=length(items);
n=length(index);

switch get(handles.reffill_check,'value')
    case get(handles.reffill_check,'min')
        items(min(index)+n:m+n)=items(min(index):m);
        set(handles.ref_lbox,'string',items)
    case get(handles.reffill_check,'max')
        while length(items)+length(index)<=l
            items(min(index)+n:m+n)=items(min(index):m);
            m=length(items);
        end
        set(handles.ref_lbox,'string',items)
end


% --- Executes on button press in ref_read.
function ref_read_Callback(hObject, eventdata, handles)
% hObject    handle to ref_read (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imagefile=ri_window('dir',handles.readdir);

fnerr=0;
k=1;
filename=cell(length(imagefile),1);
for n=1:length(imagefile)
    [pathstr,name,ext,versn] = fileparts(imagefile{n});
    name(name=='-')='_';
    if ~(double(name(1))>97 && double(name(1))<122) && ~(double(name(1))>65 && double(name(1))<90)
        name=['ref',name];
    end
    if isvarname(name)
        filename{k}=name;
        k=k+1;
        imagedata=double(imread(imagefile{n}))/255;
        if size(imagedata,3)==3
            imagedata=(imagedata(:,:,1)+imagedata(:,:,2)+imagedata(:,:,3))./3;
        elseif size(imagedata,3)~=1
            imagedata=imagedata(:,:,1);
        end
        handles.refs.(name)=imagedata;
    else
        fnerr=1;
    end
end
if fnerr
    warndlg('The name of the image file is not correct, please rename the image file','Read Image Warning')
end
if ~isempty(n)
    handles.readdir=pathstr;
    if k>1
        set(handles.ref_lbox,'string',sort(fieldnames(handles.refs)))
    end
end
guidata(hObject,handles)


% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
holoitems=get(handles.holo_lbox,'string');
objitems=get(handles.obj_lbox,'string');
refitems=get(handles.ref_lbox,'string');
rot=(get(handles.holorot_check,'value')==get(handles.holorot_check,'max'));
seven=(get(handles.sizeeven_check,'value')==get(handles.sizeeven_check,'max'));

sizeerr=0;
for n=1:length(holoitems)
    [M,N]=size(handles.holograms.(holoitems{n}));
    t=-1;
    if n<=length(objitems) && isequal([M,N],size(handles.objs.(objitems{n})))
        handles.holograms.(holoitems{n})=handles.holograms.(holoitems{n})-handles.objs.(objitems{n});
        t=t+1;
    elseif n<=length(objitems) && ~isequal([M,N],size(handles.objs.(objitems{n})))
        errordlg('The size of the images are not same, nothing is done to the holograms','Remove Zero Order Error','modal')
        return
    end
    if n<=length(refitems) && isequal([M,N],size(handles.refs.(refitems{n})))
        handles.holograms.(holoitems{n})=handles.holograms.(holoitems{n})-handles.refs.(refitems{n});
        t=t+1;
    elseif n<=length(refitems) && ~isequal([M,N],size(handles.refs.(refitems{n})))
        errordlg('The size of the images are not same, nothing is done to the holograms','Remove Zero Order Error','modal')
        return
    end
    if isequal([M,N],size(handles.background))
        handles.holograms.(holoitems{n})=handles.holograms.(holoitems{n})+t.*handles.background;
    elseif ~isempty(handles.background)
        errordlg('The size of the images are not same, nothing is done to the holograms','Remove Zero Order Error','modal')
        return
    end
    if seven
        if rem(M,2)~=0
            handles.holograms.(holoitems{n})=[handles.holograms.(holoitems{n});zeros(1,N)];
            M=M+1;
        end
        if rem(N,2)~=0
            handles.holograms.(holoitems{n})=[handles.holograms.(holoitems{n}),zeros(M,1)];
        end
    end
end

if rot
    for n=1:length(holoitems)
        handles.holograms.(holoitems{n})=rot90(handles.holograms.(holoitems{n}),2);
    end
end

set(hObject,'enable','off')

guidata(hObject,handles)

uiresume(handles.rzo_window)


% --- Executes on button press in read_background.
function read_background_Callback(hObject, eventdata, handles)
% hObject    handle to read_background (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( ...
{'*.tif;*.bmp;*.jpg','Image Files (*.tif,*.bmp,*.jpg)';...
    '*.tif','Tif Image Files (*.tif)';...
    '*.bmp','Bmp Image Files (*.bmp)';...
    '*.jpg','Jpg Image Files (*.jpg)';...
    '*.*',  'All Files (*.*)'}, ...
    'Read Background Image');
% If "Cancel" is selected then return
if isequal([filename,pathname],[0,0])
    return
end

file = fullfile(pathname,filename);
found = 0;
pass = 0;
if exist(file)
    found=1;
    [pathstr,name,ext,versn] = fileparts(file);
    if exist(file)==2 && sum(strcmp(ext,{'.tif';'.bmp';'.jpg'}))
        pass=1;
    end
end

if pass
    imagedata=double(imread(file))/255;
    if size(imagedata,3)==3
        imagedata=(imagedata(:,:,1)+imagedata(:,:,2)+imagedata(:,:,3))./3;
    elseif size(imagedata,3)~=1
        imagedata=imagedata(:,:,1);
    end
    handles.background=imagedata;
    set(handles.bg_filepath,'string',file)
    guidata(hObject,handles)
else
    if found
        str='File format illegal';
    else
        str='File not found';
    end
    errordlg(str,'File Open Error');
end



% --- Executes during object creation, after setting all properties.
function bg_filepath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg_filepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function bg_filepath_Callback(hObject, eventdata, handles)
% hObject    handle to bg_filepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bg_filepath as text
%        str2double(get(hObject,'String')) returns contents of bg_filepath as a double
file = get(handles.bg_filepath,'string');
if isempty(file)
    handles.background=[];
    return
end
found = 0;
pass = 0;
if exist(file)
    found=1;
    [pathstr,name,ext,versn] = fileparts(file);
    if exist(file)==2 && sum(strcmp(ext,{'.tif';'.bmp';'.jpg'}))
        pass=1;
    end
end

if pass
    imagedata=double(imread(file))/255;
    if size(imagedata,3)==3
        imagedata=(imagedata(:,:,1)+imagedata(:,:,2)+imagedata(:,:,3))./3;
    elseif size(imagedata,3)~=1
        imagedata=imagedata(:,:,1);
    end
    handles.background=imagedata;
    set(handles.bg_filepath,'string',file)
    guidata(hObject,handles)
else
    if found
        str='File format illegal';
    else
        str='File not found';
    end
    errordlg(str,'File Open Error');
end


% --- Executes on button press in objfill_check.
function objfill_check_Callback(hObject, eventdata, handles)
% hObject    handle to objfill_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of objfill_check


% --- Executes on button press in reffill_check.
function reffill_check_Callback(hObject, eventdata, handles)
% hObject    handle to reffill_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of reffill_check


% --- Executes when user attempts to close rzo_window.
function rzo_window_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to rzo_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(handles.rzo_window, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(handles.rzo_window);
else
    % The GUI is no longer waiting, just close it
    delete(handles.rzo_window);
end


% --- Executes on button press in holorot_check.
function holorot_check_Callback(hObject, eventdata, handles)
% hObject    handle to holorot_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of holorot_check


% --- Executes on button press in sizeeven_check.
function sizeeven_check_Callback(hObject, eventdata, handles)
% hObject    handle to sizeeven_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sizeeven_check


