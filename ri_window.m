function varargout = ri_window(varargin)
% RI_WINDOW M-file for ri_window.fig
%      RI_WINDOW, by itself, creates a new RI_WINDOW or raises the existing
%      singleton*.
%
%      H = RI_WINDOW returns the handle to a new RI_WINDOW or the handle to
%      the existing singleton*.
%
%      RI_WINDOW('Property','Value',...) creates a new RI_WINDOW using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to ri_window_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      RI_WINDOW('CALLBACK') and RI_WINDOW('CALLBACK',hObject,...) call the
%      local function named CALLBACK in RI_WINDOW.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ri_window

% Last Modified by GUIDE v2.5 18-Jul-2007 21:28:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ri_window_OpeningFcn, ...
                   'gui_OutputFcn',  @ri_window_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before ri_window is made visible.
function ri_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for ri_window
handles.output = hObject;
handles.fop='';

% Update handles structure
guidata(hObject, handles);

handles.localdrives=drivedtct;
guidata(hObject, handles);
set(handles.drive_selection,'string',handles.localdrives)

initial_dir = handles.localdrives{1};
if nargin > 4
    for n=1:2:length(varargin)
        if strcmpi(varargin{n},'dir')
            if exist(varargin{n+1})==7
                initial_dir = varargin{n+1};
            end
        end
    end
end
% Populate the listbox
load_listbox(initial_dir,handles)

% UIWAIT makes ri_window wait for user response (see UIRESUME)
uiwait(handles.ri_window);


% --- Outputs from this function are returned to the command line.
function varargout = ri_window_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.fop;
delete(handles.ri_window)


% --- Executes during object creation, after setting all properties.
function ri_lbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ri_lbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ri_lbox.
function ri_lbox_Callback(hObject, eventdata, handles)
% hObject    handle to ri_lbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ri_lbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ri_lbox
if strcmp(get(handles.ri_window,'SelectionType'),'open')
	index_selected = get(handles.ri_lbox,'Value');
    if length(index_selected)>1
        return
    end
	file_list = get(handles.ri_lbox,'String');	
	filename = file_list{index_selected};
    crtdir=get(handles.current_dir,'string');
	if handles.is_dir(handles.sorted_index(index_selected))
        if strcmp(filename,'..')
            mk=max(find(crtdir=='\'));
            crtdir(mk:end)=[];
        elseif strcmp(filename,'.')
        else
            crtdir=fullfile(crtdir,filename);
        end
		load_listbox(crtdir,handles)
    else
        [path,name,ext,ver] = fileparts(filename);
        extcell={'.tif';'.bmp';'.jpg'};
        if sum(strcmpi(extcell,ext))
            handles.fop={fullfile(crtdir,filename)};
            uiresume(handles.ri_window);
            guidata(hObject,handles)
        else
            errordlg('The type of the image file is not correct','File Type Error','modal')
            return
        end
    end
end


% --- Executes during object creation, after setting all properties.
function drive_selection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drive_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in drive_selection.
function drive_selection_Callback(hObject, eventdata, handles)
% hObject    handle to drive_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns drive_selection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drive_selection
index_selected = get(handles.drive_selection,'Value');
load_listbox(handles.localdrives{index_selected},handles);


% --- Executes on button press in read.
function read_Callback(hObject, eventdata, handles)
% hObject    handle to read (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(handles.ri_lbox,'Value');
file_list = get(handles.ri_lbox,'String');
filename = file_list(index_selected);
wrongtype=0;
for n=1:length(filename)
    if handles.is_dir(handles.sorted_index(index_selected(n)))
        wrongtype=1;
        break
    else
        [path,name,ext,ver] = fileparts(filename{n});
        extcell={'.tif';'.bmp';'.jpg'};
        if ~sum(strcmpi(extcell,ext))
            wrongtype=1;
            break
        end
    end
end
if wrongtype
    errordlg('The type of the image file is not correct','File Type Error','modal')
    return
else
    crtdir=get(handles.current_dir,'string');
    files=cell(length(filename),1);
    for n=1:length(filename)
        files{n}=fullfile(crtdir,filename{n});
    end
    handles.fop = files;
    guidata(hObject,handles)
    uiresume(handles.ri_window);
end


% --- Detect the local drives
function drives=drivedtct()
k=1;
for n=67:90
    str=[char(n),':\'];
    if exist(str)==7
        drives{k,1}=str;
        k=k+1;
    end
end


% ------------------------------------------------------------
% Read the current directory and sort the names
% ------------------------------------------------------------
function load_listbox(dir_path,handles)
dir_struct = dir(dir_path);
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
handles.file_names = sorted_names;
handles.is_dir = [dir_struct.isdir];
handles.sorted_index = [sorted_index];
guidata(handles.ri_window,handles)
set(handles.ri_lbox,'String',handles.file_names,'Value',1)
set(handles.current_dir,'String',dir_path)


% --- Executes when user attempts to close ri_window.
function ri_window_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to ri_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(handles.ri_window, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(handles.ri_window);
else
    % The GUI is no longer waiting, just close it
    delete(handles.ri_window);
end

