function varargout = rcunwrap_window(varargin)                                      
% RCUNWRAP_WINDOW M-file for rcunwrap_window.fig
%      RCUNWRAP_WINDOW, by itself, creates a new RCUNWRAP_WINDOW or raises the existing
%      singleton*. 
%
%      H = RCUNWRAP_WINDOW returns the handle to a new RCUNWRAP_WINDOW or the handle to
%      the existing singleton*.
%
%      RCUNWRAP_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RCUNWRAP_WINDOW.M with the given input arguments.
%
%      RCUNWRAP_WINDOW('Property','Value',...) creates a new RCUNWRAP_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rcunwrap_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rcunwrap_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rcunwrap_window

% Last Modified by GUIDE v2.5 05-Sep-2007 10:24:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rcunwrap_window_OpeningFcn, ...
                   'gui_OutputFcn',  @rcunwrap_window_OutputFcn, ...
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


% --- Executes just before rcunwrap_window is made visible.
function rcunwrap_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rcunwrap_window (see VARARGIN)
handles.phase=[];
handles.upm=[];

if nargin > 4
    for n=1:2:length(varargin)
        if strcmpi(varargin{n},'phasemaps')
            handles.phase=varargin{n+1};
        end
    end
end

% Choose default command line output for rcunwrap_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rcunwrap_window wait for user response (see UIRESUME)
uiwait(handles.rcunwrap_window);


% --- Outputs from this function are returned to the command line.
function varargout = rcunwrap_window_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if isempty(findobj('type','figure','tag','rcunwrap_window'))
    varargout{1}=[];
    return
end

varargout{1}=handles.upm;

delete(handles.rcunwrap_window)


% --- Executes during object creation, after setting all properties.
function refind_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to refind_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function refind_edit_Callback(hObject, eventdata, handles)
% hObject    handle to refind_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of refind_edit as text
%        str2double(get(hObject,'String')) returns contents of refind_edit as a double
refind=round(abs(str2num(get(hObject,'string'))));
if length(refind)>1 || isequal(refind,0)
    set(hObject,'string','');
else
    set(hObject,'string',num2str(refind));
end


% --- Executes when user attempts to close rcunwrap_window.
function rcunwrap_window_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to rcunwrap_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(handles.rcunwrap_window, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(handles.rcunwrap_window);
else
    % The GUI is no longer waiting, just close it
    delete(handles.rcunwrap_window);
end


% --- Executes on button press in unwrap_button.
function unwrap_button_Callback(hObject, eventdata, handles)
% hObject    handle to unwrap_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.phase)
    return
end

items=sort(fieldnames(handles.phase));

prefix=get(handles.prefix_edit,'string');
if get(handles.rowwise_radio,'value')==get(handles.rowwise_radio,'max')
    dim=2;
else
    dim=1;
end
tol=str2num(get(handles.tol_edit,'string')).*pi;
ind=str2num(get(handles.refind_edit,'string'));

for n=1:length(items)
    if ind>handles.phase(2).(items{n}).MN2(dim)
        ind=[];
    end
    handles.upm(1).([prefix,items{n}])=unwrap2(handles.phase(1).(items{n}),dim,ind,tol);
    handles.upm(1).([prefix,items{n}])(~handles.phase(4).(items{n}))=NaN;
    handles.upm(2).([prefix,items{n}])=handles.phase(2).(items{n});
    handles.upm(3).([prefix,items{n}])=handles.phase(3).(items{n});
    handles.upm(4).([prefix,items{n}])=handles.phase(4).(items{n});
end

guidata(hObject,handles)

set(hObject,'enable','off')
uiresume(handles.rcunwrap_window);


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
prefix=get(hObject,'string');
if ~isvarname(prefix)
    set(hObject,'string','')
end


% --- Executes on button press in rowwise_radio.
function rowwise_radio_Callback(hObject, eventdata, handles)
% hObject    handle to rowwise_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rowwise_radio
if get(handles.columnwise_radio,'value')==get(handles.columnwise_radio,'max')
    set(hObject,'value',get(hObject,'max'))
    set(handles.columnwise_radio,'value',get(handles.columnwise_radio,'min'))
else
    set(hObject,'value',get(hObject,'max'))
end


% --- Executes on button press in columnwise_radio.
function columnwise_radio_Callback(hObject, eventdata, handles)
% hObject    handle to columnwise_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of columnwise_radio
if get(handles.rowwise_radio,'value')==get(handles.rowwise_radio,'max')
    set(hObject,'value',get(hObject,'max'))
    set(handles.rowwise_radio,'value',get(handles.rowwise_radio,'min'))
else
    set(hObject,'value',get(hObject,'max'))
end


% --- Executes during object creation, after setting all properties.
function tol_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tol_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function tol_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tol_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tol_edit as text
%        str2double(get(hObject,'String')) returns contents of tol_edit as a double
tol=str2num(get(hObject,'string'));
if isempty(tol) || length(tol)>1 || tol<=0 || tol>2
    set(hObject,'string','1')
else
    set(hObject,'string',num2str(tol));
end

