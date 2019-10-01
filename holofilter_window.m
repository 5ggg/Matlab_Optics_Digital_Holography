function varargout = holofilter_window(varargin)
% HOLOFILTER_WINDOW M-file for holofilter_window.fig
%      HOLOFILTER_WINDOW, by itself, creates a new HOLOFILTER_WINDOW or raises the existing
%      singleton*.
%
%      H = HOLOFILTER_WINDOW returns the handle to a new HOLOFILTER_WINDOW or the handle to
%      the existing singleton*.
%
%      HOLOFILTER_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HOLOFILTER_WINDOW.M with the given input arguments.
%
%      HOLOFILTER_WINDOW('Property','Value',...) creates a new HOLOFILTER_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before holofilter_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to holofilter_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help holofilter_window

% Last Modified by GUIDE v2.5 19-Aug-2007 11:43:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @holofilter_window_OpeningFcn, ...
                   'gui_OutputFcn',  @holofilter_window_OutputFcn, ...
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


% --- Executes just before holofilter_window is made visible.
function holofilter_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to holofilter_window (see VARARGIN)
axes(handles.frequency_axes)
imagesc(ones(576,768)),colormap(gray);
axis equal tight;

handles.holograms=[];
handles.frequency=[];
handles.ondisplay=[];
set(handles.holo_lbox,'String',cell(1,0),'value',1);

if nargin > 4
    for n=1:2:length(varargin)
        if strcmpi(varargin{n},'holograms')
            handles.holograms=varargin{n+1};
            if ~isempty(handles.holograms)
                set(handles.holo_lbox,'string',sort(fieldnames(handles.holograms)))
            end
        end
    end
end

% Choose default command line output for holofilter_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes holofilter_window wait for user response (see UIRESUME)
uiwait(handles.holofilter_window);


% --- Outputs from this function are returned to the command line.
function varargout = holofilter_window_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if ~isempty(findobj('type','figure','tag','holofilter_window'))
    if strcmp(get(handles.done_button,'enable'),'off')
        varargout{1} = handles.holograms;
    else
        varargout{1} = [];
    end
    delete(handles.holofilter_window)
else
    varargout{1} = [];
end


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
if strcmp(get(handles.holofilter_window,'SelectionType'),'open')
    fourier_button_Callback(handles.fourier_button,[],handles);
end


% --- Executes during object creation, after setting all properties.
function fredisp_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fredisp_slider (see GCBO)
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
function fredisp_slider_Callback(hObject, eventdata, handles)
% hObject    handle to fredisp_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
if ~isempty(handles.ondisplay)
    axes(handles.frequency_axes)
    v=get(handles.fredisp_slider,'value');
    imagesc(zero2one(abs(handles.frequency.(handles.ondisplay))),[0,max(v.^5,eps)]),colormap(gray);
    axis equal tight
end


% --- Executes on button press in fourier_button.
function fourier_button_Callback(hObject, eventdata, handles)
% hObject    handle to fourier_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.holo_lbox,'string');
index=get(handles.holo_lbox,'value');
if isempty(items) || length(index)>1
    return
end

selected=items{index};
if ~isfield(handles.frequency,selected)
    handles.frequency.(selected) = fourier(handles.holograms.(selected));
end

axes(handles.frequency_axes)
v=get(handles.fredisp_slider,'value');
imagesc(zero2one(abs(handles.frequency.(selected))),[0,max(v.^5,eps)]),colormap(gray);
axis equal tight

set(handles.fretitle_text,'string',['Spacial Frequency Spectrum of the Hologram: ',selected])

handles.ondisplay=selected;
guidata(hObject,handles)


% --- Executes on button press in filter_button.
function filter_button_Callback(hObject, eventdata, handles)
% hObject    handle to filter_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.holo_lbox,'string');
index=get(handles.holo_lbox,'value');
if isempty(items)
    return
end

xrange=round(str2num(get(handles.xrange_edit,'string')));
yrange=round(str2num(get(handles.yrange_edit,'string')));

if isempty(xrange) && isempty(yrange)
    return
end

if get(handles.all_radio,'value')==get(handles.all_radio,'max')
    index=(1:length(items));
end

rangeerr=0;
for n=index
    currentholo=items{n};
    [M,N]=size(handles.holograms.(currentholo));
    if isempty(xrange)
        xrange=1:N;
    elseif isempty(yrange)
        yrange=1:M;
    end
    if sum(xrange<1) || sum(xrange>N) || sum(yrange<1) || sum(yrange>M)
        errordlg('Filtered area out of image, nothing is done to the holograms','Filter Error','modal')
        rangeerr=1;
        return
    end
    if ~isfield(handles.frequency,currentholo)
        handles.frequency.(currentholo) = fourier(handles.holograms.(currentholo));
    end
    handles.frequency.(currentholo)(yrange,xrange)=0;
    handles.holograms.(currentholo) = invfourier(handles.frequency.(currentholo));
end

if ~isempty(handles.ondisplay)
    axes(handles.frequency_axes)
    v=get(handles.fredisp_slider,'value');
    imagesc(zero2one(abs(handles.frequency.(handles.ondisplay))),[0,max(v.^5,eps)]),colormap(gray);
    axis equal tight
end

if ~rangeerr
    guidata(hObject,handles);
end


% --- Executes during object creation, after setting all properties.
function xrange_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xrange_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function xrange_edit_Callback(hObject, eventdata, handles)
% hObject    handle to xrange_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xrange_edit as text
%        str2double(get(hObject,'String')) returns contents of xrange_edit as a double


% --- Executes during object creation, after setting all properties.
function yrange_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yrange_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function yrange_edit_Callback(hObject, eventdata, handles)
% hObject    handle to yrange_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yrange_edit as text
%        str2double(get(hObject,'String')) returns contents of yrange_edit as a double


% --- Executes on button press in sfim_button.
function sfim_button_Callback(hObject, eventdata, handles)
% hObject    handle to sfim_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.frequency_axes)
[x,y] = ginput(2);
if isempty(x) || isempty(y)
    return
end
x=round(sort(x));
y=round(sort(y));

if isempty(handles.ondisplay)
    M=576;
    N=768;
else
    [M,N]=size(handles.holograms.(handles.ondisplay));
end

if x(1)<1
    x(1)=1;
end
if x(2)>N
    x(2)=N;
end

if y(1)<1
    y(1)=1;
end
if y(2)>M
    y(2)=M;
end

if x(1)>N || x(2)<1 || y(1)>M || y(2)<1
    x=[];
    y=[];
end

if isempty(x) || isempty(y)
    set(handles.xrange_edit,'string','');
    set(handles.yrange_edit,'string','');
else
    set(handles.xrange_edit,'string',[int2str(x(1)),':',int2str(x(2))]);
    set(handles.yrange_edit,'string',[int2str(y(1)),':',int2str(y(2))]);
end


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


% --- Executes when user attempts to close holofilter_window.
function holofilter_window_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to holofilter_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(handles.holofilter_window, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(handles.holofilter_window);
else
    % The GUI is no longer waiting, just close it
    delete(handles.holofilter_window);
end


% --- Executes on button press in done_button.
function done_button_Callback(hObject, eventdata, handles)
% hObject    handle to done_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(get(handles.holofilter_window, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    set(hObject,'enable','off')
    uiresume(handles.holofilter_window);
else
    % The GUI is no longer waiting, just close it
    delete(handles.holofilter_window);
end


