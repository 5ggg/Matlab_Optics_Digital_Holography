function varargout = dmin_window(varargin)
% DMIN_WINDOW M-file for dmin_window.fig
%      DMIN_WINDOW, by itself, creates a new DMIN_WINDOW or raises the existing
%      singleton*.
%
%      H = DMIN_WINDOW returns the handle to a new DMIN_WINDOW or the handle to
%      the existing singleton*.
%
%      DMIN_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DMIN_WINDOW.M with the given input arguments.
%
%      DMIN_WINDOW('Property','Value',...) creates a new DMIN_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dmin_window_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dmin_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dmin_window

% Last Modified by GUIDE v2.5 21-Jul-2007 20:15:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dmin_window_OpeningFcn, ...
                   'gui_OutputFcn',  @dmin_window_OutputFcn, ...
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


% --- Executes just before dmin_window is made visible.
function dmin_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dmin_window (see VARARGIN)
if nargin > 4
    for n=1:2:length(varargin)
        if strcmpi(varargin{n},'hwp')
            hwp=varargin{n+1};
            set(handles.N_edit,'string',num2str(hwp.N));
            set(handles.M_edit,'string',num2str(hwp.M));
            set(handles.dx_edit,'string',num2str(hwp.dx));
            set(handles.dy_edit,'string',num2str(hwp.dy));
            set(handles.wl_edit,'string',num2str(hwp.lambda));
        end
    end
end

calcu_button_Callback(handles.calcu_button,[],handles);

% Choose default command line output for dmin_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dmin_window wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dmin_window_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function N_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to N_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function N_edit_Callback(hObject, eventdata, handles)
% hObject    handle to N_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of N_edit as text
%        str2double(get(hObject,'String')) returns contents of N_edit as a double


% --- Executes during object creation, after setting all properties.
function M_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to M_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function M_edit_Callback(hObject, eventdata, handles)
% hObject    handle to M_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of M_edit as text
%        str2double(get(hObject,'String')) returns contents of M_edit as a double


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


% --- Executes during object creation, after setting all properties.
function width_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function width_edit_Callback(hObject, eventdata, handles)
% hObject    handle to width_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width_edit as text
%        str2double(get(hObject,'String')) returns contents of width_edit as a double


% --- Executes during object creation, after setting all properties.
function height_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function height_edit_Callback(hObject, eventdata, handles)
% hObject    handle to height_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of height_edit as text
%        str2double(get(hObject,'String')) returns contents of height_edit as a double


% --- Executes on button press in zos_check.
function zos_check_Callback(hObject, eventdata, handles)
% hObject    handle to zos_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zos_check
if get(handles.zos_check,'value')==get(handles.zos_check,'Max')
    set(handles.psm_check,'value',get(handles.psm_check,'Min'))
end


% --- Executes on button press in psm_check.
function psm_check_Callback(hObject, eventdata, handles)
% hObject    handle to psm_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of psm_check
if get(handles.psm_check,'value')==get(handles.psm_check,'Max')
    set(handles.zos_check,'value',get(handles.zos_check,'Min'))
end


% --- Executes during object creation, after setting all properties.
function wl_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wl_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function wl_edit_Callback(hObject, eventdata, handles)
% hObject    handle to wl_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wl_edit as text
%        str2double(get(hObject,'String')) returns contents of wl_edit as a double


% --- Executes on button press in calcu_button.
function calcu_button_Callback(hObject, eventdata, handles)
% hObject    handle to calcu_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
N=str2num(get(handles.N_edit,'string'));
M=str2num(get(handles.M_edit,'string'));
dx=str2num(get(handles.dx_edit,'string'));
dy=str2num(get(handles.dy_edit,'string'));
lambda=str2num(get(handles.wl_edit,'string')).*1e-6;
lox=str2num(get(handles.width_edit,'string'));
loy=str2num(get(handles.height_edit,'string'));

if get(handles.psm_check,'value')==get(handles.psm_check,'Max')
    c=1;
elseif get(handles.zos_check,'value')==get(handles.zos_check,'Max')
    c=2;
else
    c=4;
end

if get(handles.xdrct_radio,'value')==get(handles.xdrct_radio,'Max')
    dminx=c.*(N*dx+lox).*dx./lambda;
    dminy=(M*dy+loy).*dy./lambda;
else
    dminx=(N*dx+lox).*dx./lambda;
    dminy=c.*(M*dy+loy).*dy./lambda;
end

dminx=num2str(dminx,'%5.0f');
dminy=num2str(dminy,'%5.0f');
str=['X : ',dminx,' , Y : ',dminy,' mm'];
set(handles.rsltdisp_text,'string',str);


% --- Executes on button press in xdrct_radio.
function xdrct_radio_Callback(hObject, eventdata, handles)
% hObject    handle to xdrct_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xdrct_radio
v=get(handles.ydrct_radio,'value');
vmax=get(handles.ydrct_radio,'Max');
vmin=get(handles.ydrct_radio,'Min');
set(handles.ydrct_radio,'value',vmax+vmin-v)


% --- Executes on button press in ydrct_radio.
function ydrct_radio_Callback(hObject, eventdata, handles)
% hObject    handle to ydrct_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ydrct_radio
v=get(handles.xdrct_radio,'value');
vmax=get(handles.xdrct_radio,'Max');
vmin=get(handles.xdrct_radio,'Min');
set(handles.xdrct_radio,'value',vmax+vmin-v)


