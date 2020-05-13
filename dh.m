%  Digital holography main window
      
function varargout = dh(varargin)
% dh M-file for dh.fig
%      dh, by itself, creates a new dh or raises the existing
%      singleton*.
%
%      H = dh returns the handle to a new dh or the handle to
%      the existing singleton*.
%
%      dh('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in dh.M with the given input arguments.
%
%      dh('Property','Value',...) creates a new dh or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dh_OpeningFunction gets called.  An
%      unrecognized property name or invalrzo_windowid value makes property application
%      stop.  All inputs are passed to dh_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dh

% Last Modified by GUIDE v2.5 26-Dec-2007 13:52:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dh_OpeningFcn, ...
                   'gui_OutputFcn',  @dh_OutputFcn, ...
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


% --- Executes just before dh is made visible.
function dh_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dh (see VARARGIN)
handles.holograms=[];
handles.reconstructions=[];
handles.phasemaps=[];
handles.upm=[];

handles.hwp.N=768;
handles.hwp.M=576;
handles.hwp.dx=0.0080922;
handles.hwp.dy=0.0080555;
handles.hwp.lambda=532;

handles.parameters.dist=[];
handles.parameters.center=[];
handles.parameters.b=[];
handles.parameters.MN2=[];
handles.parameters.dxy2o=[];
handles.parameters.dxy2=[];
handles.parameters.mag=1;
handles.parameters.dalpha=[];
handles.parameters.dbeta=[];
handles.parameters.alpha=[];
handles.parameters.beta=[];

handles.LastFile=[];
handles.readdir='C:\';

handles.cdtype='';          % current data type
handles.cdname='';          % current data name

set(handles.file_save,'enable','off');
set(handles.file_saveas,'enable','off');
set(handles.holo_lbox,'String',cell(1,0),'value',1);
set(handles.recon_lbox,'String',cell(1,0),'value',1);
set(handles.phase_lbox,'String',cell(1,0),'value',1);
set(handles.upm_lbox,'String',cell(1,0),'value',1);
%set(handles.holo_frame,'enable','off')
%set(handles.holo_frame,'ButtonDownFcn','selectmoveresize')
% Choose default command line output for dh
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dh wait for user response (see UIRESUME)
% uiwait(handles.dh);


% --- Outputs from this function are returned to the command line.
function varargout = dh_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function file_open_Callback(hObject, eventdata, handles)
% hObject    handle to file_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
svd=get(handles.file_save,'enable');
if strcmp(svd,'on')
    selection = questdlg('Work not saved, do you want to save?','Open a new work','Yes','No','Cancel','Yes');
    switch selection
        case 'Yes'
            file_save_Callback(handles.file_save, eventdata, handles);
            return
        case 'Cancel'
            return
        case ''
            return
    end
end

[filename,pathname]=uigetfile({'*.mat','All MAT-Files(*.mat)'},'Open Data File');
% If "Cancel" is selected then return
if isequal([filename,pathname],[0,0])
    return
    % Otherwise construct the fullfilename and Check and load the file.
else
    File = fullfile(pathname,filename);
    % if the MAT-file is not valid, do not save the name
    if Check_And_Load(File,handles,{'holograms';'reconstructions';'phasemaps';'upm';'hwp';'parameters';'LastFile';'readdir'})
        handles=guidata(hObject);
        handles.LastFile = File;
        guidata(hObject,handles)
        set(handles.file_saveas,'enable','on');
    end
end



% --------------------------------------------------------------------
function file_save_Callback(hObject, eventdata, handles)
% hObject    handle to file_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
File = handles.LastFile;
if isempty(File)
    [filename, pathname] = uiputfile( {'*.mat';'*.*'}, 'Save');
    if isequal([filename,pathname],[0,0])
        return
    else
        File = fullfile(pathname,filename);
        handles.LastFile = File;
        guidata(hObject,handles)
    end
end
Save_Data(File,handles,{'holograms';'reconstructions';'phasemaps';'upm';'hwp';'parameters';'LastFile';'readdir'});
set(handles.file_save,'enable','off');


% --------------------------------------------------------------------
function file_readimage_Callback(hObject, eventdata, handles)
% hObject    handle to file_readimage (see GCBO)
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
        name=['holo',name];
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
        handles.holograms.(name)=imagedata;
        [handles.hwp.M,handles.hwp.N]=size(imagedata);
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
        set(handles.holo_lbox,'string',sort(fieldnames(handles.holograms)))
        set(handles.file_save,'enable','on')
        set(handles.file_saveas,'enable','on')
    end
end
guidata(hObject,handles)


% --------------------------------------------------------------------
function file_saveas_Callback(hObject, eventdata, handles)
% hObject    handle to file_saveas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile( {'*.mat';'*.*'}, 'Save as');
if isequal([filename,pathname],[0,0])
    return
else
    File = fullfile(pathname,filename);
    handles.LastFile = File;
    guidata(hObject,handles);
end
Save_Data(File,handles,{'holograms';'reconstructions';'phasemaps';'upm';'hwp';'parameters';'LastFile';'readdir'});
set(handles.file_save,'enable','off');


% --------------------------------------------------------------------
function view_menu_Callback(hObject, eventdata, handles)
% hObject    handle to view_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function view_holo_Callback(hObject, eventdata, handles)
% hObject    handle to view_holo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function view_recon_Callback(hObject, eventdata, handles)
% hObject    handle to view_recon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function view_phase_Callback(hObject, eventdata, handles)
% hObject    handle to view_phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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
showinfo(hObject,handles);
if strcmp(get(handles.dh,'SelectionType'),'open')
    holo_disp_Callback(handles.holo_disp, [], handles);
end


% --- Executes on button press in holo_load.
function holo_load_Callback(hObject, eventdata, handles)
% hObject    handle to holo_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.mat','All MAT-Files(*.mat)'},'Load Data');
% If "Cancel" is selected then return
if isequal([filename,pathname],[0,0])
    return
    % Otherwise construct the fullfilename and Check and load the file.
else
    File = fullfile(pathname,filename);
    % if the MAT-file is not valid, do not save the name
    if Check_And_Load(File,handles,{'holograms'});
        set(handles.file_save,'enable','on');
        set(handles.file_saveas,'enable','on');
    end
end
 

% --- Executes on button press in holo_save.
function holo_save_Callback(hObject, eventdata, handles)
% hObject    handle to holo_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile( {'*.mat';'*.*'}, 'Save');
if isequal([filename,pathname],[0,0])
    return
else
    File = fullfile(pathname,filename);
end
Save_Data(File,handles,{'holograms'});



% --- Executes on button press in holo_delete.
function holo_delete_Callback(hObject, eventdata, handles)
% hObject    handle to holo_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.holo_lbox,'string');
if isempty(items)
    return
end
index=get(handles.holo_lbox,'value');

handles.holograms=rmfield(handles.holograms,items(index));
items(index)=[];
set(handles.holo_lbox,'value',1);
set(handles.holo_lbox,'string',items);

set(handles.file_save,'enable','on')
set(handles.file_saveas,'enable','on')

guidata(hObject,handles)


% --- Executes on button press in holo_disp.
function holo_disp_Callback(hObject, eventdata, handles)
% hObject    handle to holo_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index=get(handles.holo_lbox,'value');
holostr=get(handles.holo_lbox,'string');
if isempty(holostr)
    index=[];
end
for n=index
    figname=['Hologram: ',holostr{n}];
    figure('numbertitle','off','name',figname,'userdata','digitalholography')
    imagesc(abs(handles.holograms.(holostr{n}))),colormap(gray);
    axis equal tight
end


% --- Executes on button press in recon_load.
function recon_load_Callback(hObject, eventdata, handles)
% hObject    handle to recon_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.mat','All MAT-Files(*.mat)'},'Load Data');
% If "Cancel" is selected then return
if isequal([filename,pathname],[0,0])
    return
    % Otherwise construct the fullfilename and Check and load the file.
else
    File = fullfile(pathname,filename);
    % if the MAT-file is not valid, do not save the name
    if Check_And_Load(File,handles,{'reconstructions'});
        set(handles.file_save,'enable','on');
        set(handles.file_saveas,'enable','on');
    end
end


% --- Executes on button press in recon_save.
function recon_save_Callback(hObject, eventdata, handles)
% hObject    handle to recon_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile( {'*.mat';'*.*'}, 'Save');
if isequal([filename,pathname],[0,0])
    return
else
    File = fullfile(pathname,filename);
end
Save_Data(File,handles,{'reconstructions'});


% --- Executes on button press in recon_delete.
function recon_delete_Callback(hObject, eventdata, handles)
% hObject    handle to recon_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.recon_lbox,'string');
if isempty(items)
    return
end
index=get(handles.recon_lbox,'value');

handles.reconstructions=rmfield(handles.reconstructions,items(index));
items(index)=[];
set(handles.recon_lbox,'value',1);
set(handles.recon_lbox,'string',items);

set(handles.file_save,'enable','on')
set(handles.file_saveas,'enable','on')

guidata(hObject,handles)


% --- Executes on button press in recon_disp.
function recon_disp_Callback(hObject, eventdata, handles)
% hObject    handle to recon_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index=get(handles.recon_lbox,'value');
reconstr=get(handles.recon_lbox,'string');
if isempty(reconstr)
    index=[];
end
for n=index
    figname=['Reconstructed Image: ',reconstr{n}];
    figure('numbertitle','off','name',figname,'userdata','digitalholography')
    opticimage(abs(handles.reconstructions(1).(reconstr{n})),handles.reconstructions(2).(reconstr{n}).dxy2(1),...
        handles.reconstructions(2).(reconstr{n}).dxy2(2),handles.reconstructions(2).(reconstr{n}).center);
end


% --- Executes during object creation, after setting all properties.
function recon_lbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to recon_lbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in recon_lbox.
function recon_lbox_Callback(hObject, eventdata, handles)
% hObject    handle to recon_lbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns recon_lbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from recon_lbox
showinfo(hObject,handles);
if strcmp(get(handles.dh,'SelectionType'),'open')
    recon_disp_Callback(handles.recon_disp, [], handles);
end


% --- Executes during object creation, after setting all properties.
function phase_lbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phase_lbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in phase_lbox.
function phase_lbox_Callback(hObject, eventdata, handles)
% hObject    handle to phase_lbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns phase_lbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from phase_lbox
showinfo(hObject,handles);
if strcmp(get(handles.dh,'SelectionType'),'open')
    phase_disp_Callback(handles.phase_disp, [], handles);
end


% --- Executes on button press in phase_load.
function phase_load_Callback(hObject, eventdata, handles)
% hObject    handle to phase_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.mat','All MAT-Files(*.mat)'},'Load Data');
% If "Cancel" is selected then return
if isequal([filename,pathname],[0,0])
    return
    % Otherwise construct the fullfilename and Check and load the file.
else
    File = fullfile(pathname,filename);
    % if the MAT-file is not valid, do not save the name
    if Check_And_Load(File,handles,{'phasemaps'});
        set(handles.file_save,'enable','on');
        set(handles.file_saveas,'enable','on');
    end
end


% --- Executes on button press in phase_save.
function phase_save_Callback(hObject, eventdata, handles)
% hObject    handle to phase_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile( {'*.mat';'*.*'}, 'Save');
if isequal([filename,pathname],[0,0])
    return
else
    File = fullfile(pathname,filename);
end
Save_Data(File,handles,{'phasemaps'});


% --- Executes on button press in phase_delete.
function phase_delete_Callback(hObject, eventdata, handles)
% hObject    handle to phase_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.phase_lbox,'string');
if isempty(items)
    return
end
index=get(handles.phase_lbox,'value');

handles.phasemaps=rmfield(handles.phasemaps,items(index));
items(index)=[];
set(handles.phase_lbox,'value',1);
set(handles.phase_lbox,'string',items);

set(handles.file_save,'enable','on')
set(handles.file_saveas,'enable','on')

guidata(hObject,handles)


% --- Executes on button press in phase_disp.
function phase_disp_Callback(hObject, eventdata, handles)
% hObject    handle to phase_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index=get(handles.phase_lbox,'value');
phasestr=get(handles.phase_lbox,'string');
if isempty(phasestr)
    index=[];
end
for n=index
    figname=['Phase map: ',phasestr{n}];
    figure('numbertitle','off','name',figname,'userdata','digitalholography')
    [vx,vy]=opticimage(handles.phasemaps(2).(phasestr{n}).MN2,handles.phasemaps(2).(phasestr{n}).dxy2(1),...
        handles.phasemaps(2).(phasestr{n}).dxy2(2),handles.phasemaps(2).(phasestr{n}).center);
    imagesc(vx,vy,handles.phasemaps(1).(phasestr{n}),[-pi,pi]);colormap(gray);axis xy image;
end


%----------------------------------------------------------------------
function pass = Check_And_Load(file,handles,datatype)

found = 0;
pass = 0;

if length(datatype)>1
    str='isdh';
else 
    str=['is',datatype{1}];
end

if exist(file)
    found=1;
    [pathstr,name,ext,versn] = fileparts(file);
    if exist(file)==2 && strcmp(ext,'.mat')
        data = load(file);
        flds = sort(fieldnames(data));
        datatype{end+1,1}=str;
        datatype=sort(datatype);
        if isequal(flds,datatype) && data.(str)==1
            pass=1;
        end
    end
end

% If the file is valid, load it
if pass
    for n=1:length(datatype)
        switch datatype{n}
            case 'holograms'
                handles.holograms=data.holograms;
                if isempty(data.holograms)
                    set(handles.holo_lbox,'String','');
                else
                    set(handles.holo_lbox,'String',sort(fieldnames(data.holograms)),'value',1);
                end
            case 'reconstructions'
                handles.reconstructions=data.reconstructions;
                if isempty(data.reconstructions)
                    set(handles.recon_lbox,'String','');
                else
                    set(handles.recon_lbox,'String',sort(fieldnames(data.reconstructions)),'value',1);
                end
            case 'phasemaps'
                handles.phasemaps=data.phasemaps;
                if isempty(data.phasemaps)
                    set(handles.phase_lbox,'String','');
                else
                    set(handles.phase_lbox,'String',sort(fieldnames(data.phasemaps)),'value',1);
                end
            case 'upm'
                handles.upm=data.upm;
                if isempty(data.upm)
                    set(handles.upm_lbox,'String','');
                else
                    set(handles.upm_lbox,'String',sort(fieldnames(data.upm)),'value',1);
                end
            case 'hwp'
                handles.hwp=data.hwp;
            case 'parameters'
                handles.parameters=data.parameters;
            case 'readdir'
                handles.readdir=data.readdir;
            case 'LastFile'
                handles.LastFile=data.LastFile;
        end
    end
    guidata(handles.dh,handles);
else
    if found
        str='File format illegal';
    else
        str='File not found';
    end
    errordlg(str,'File Open Error','modal');
end


%----------------------------------------------------------------------
function Save_Data(file,handles,datatype)
if length(datatype)>1
    holograms=handles.holograms;
    save(file,'holograms');
    clear holograms
    
    reconstructions=handles.reconstructions;
    save(file,'reconstructions','-append');
    clear reconstructions
    
    phasemaps=handles.phasemaps;
    save(file,'phasemaps','-append');
    clear phasemaps
    
    upm=handles.upm;
    save(file,'upm','-append');
    clear upm
    
    hwp=handles.hwp;
    parameters=handles.parameters;
    LastFile=handles.LastFile;
    readdir=handles.readdir;
    isdh=1;
    save(file,'hwp','parameters','LastFile','readdir','isdh','-append');
else
    switch datatype{1}
        case 'holograms'
            holograms=handles.holograms;
            isholograms=1;
            save(file,'holograms','isholograms');
        case 'reconstructions'
            reconstructions=handles.reconstructions;
            isreconstructions=1;
            save(file,'reconstructions','isreconstructions');
        case 'phasemaps'
            phasemaps=handles.phasemaps;
            isphasemaps=1;
            save(file,'phasemaps','isphasemaps');
        case 'upm'
            upm=handles.upm;
            isupm=1;
            save(file,'upm','isupm');
    end
end


% --------------------------------------------------------------------
function file_new_Callback(hObject, eventdata, handles)
% hObject    handle to file_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
svd=get(handles.file_save,'enable');
if strcmp(svd,'on')
    selection = questdlg('Work not saved, do you want to save?','Reset Digital Holography','Yes','No','Cancel','Yes');
    switch selection
        case 'Yes'
            file_save_Callback(handles.file_save, eventdata, handles);
            if strcmp(get(handles.file_save,'enable'),'on')
                return
            end
        case 'Cancel'
            return
        case ''
            return
    end
end
dhreset(handles);


%----------------------------------------------------------------------
function dhreset(handles)
subwindows=findobj('type','figure','userdata','digitalholography');
delete(subwindows);
handles.holograms=[];
handles.reconstructions=[];
handles.phasemaps=[];
handles.upm=[];

handles.hwp.N=768;
handles.hwp.M=576;
handles.hwp.dx=0.0080922;
handles.hwp.dy=0.0080555;
handles.hwp.lambda=532;

handles.parameters.dist=[];
handles.parameters.center=[];
handles.parameters.b=[];
handles.parameters.MN2=[];
handles.parameters.dxy2o=[];
handles.parameters.dxy2=[];

handles.LastFile=[];
set(handles.file_save,'enable','off');
set(handles.file_saveas,'enable','off');

set(handles.holo_lbox,'String',cell(1,0),'value',1);
set(handles.recon_lbox,'String',cell(1,0),'value',1);
set(handles.phase_lbox,'String',cell(1,0),'value',1);
set(handles.upm_lbox,'String',cell(1,0),'value',1);

set(handles.infoname_text,'string','');
set(handles.infovalue_text,'string','');

guidata(handles.dh,handles)




% --------------------------------------------------------------------
function tools_menu_Callback(hObject, eventdata, handles)
% hObject    handle to tools_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function tools_mindist_Callback(hObject, eventdata, handles)
% hObject    handle to tools_mindist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dmin_window('userdata','digitalholography','hwp',handles.hwp);


% --------------------------------------------------------------------
function tools_holofilter_Callback(hObject, eventdata, handles)
% hObject    handle to tools_fourier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=holofilter_window('userdata','digitalholography','holograms',handles.holograms);
if isempty(findobj('type','figure','tag','dh'))
    return
end

if ~isempty(temp)
    handles.holograms=temp;
    set(handles.file_save,'enable','on')
    set(handles.file_saveas,'enable','on')
    guidata(hObject,handles)
end

% --------------------------------------------------------------------
function tools_rzo_Callback(hObject, eventdata, handles)
% hObject    handle to tools_rzo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=rzo_window('holograms',handles.holograms,'readdir',handles.readdir);
if ~isempty(temp)
    handles.holograms=temp;
    fn = fieldnames(temp);
    [handles.hwp.M,handles.hwp.N]=size(temp.(fn{1}));
    set(handles.file_save,'enable','on')
    set(handles.file_saveas,'enable','on')
end
guidata(hObject,handles)


% --------------------------------------------------------------------
function tools_dd_Callback(hObject, eventdata, handles)
% hObject    handle to tools_dd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.holo_lbox,'string');
index=get(handles.holo_lbox,'value');
if length(index)>1
    index=min(index);
end
if isempty(items)
    return
end
[dist,hwp]=dd_window('userdata','digitalholography','hologram',handles.holograms.(items{index}),...
    'hwp',handles.hwp,'dist',handles.parameters.dist);

if isempty(findobj('type','figure','tag','dh'))
    return
end

if ~isempty(dist) && ~isempty(hwp)
    handles.parameters.dist=dist;
    handles.hwp=hwp;
    set(handles.file_save,'enable','on')
    set(handles.file_saveas,'enable','on')
    guidata(hObject,handles)
end


% --------------------------------------------------------------------
function recon_menu_Callback(hObject, eventdata, handles)
% hObject    handle to recon_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function recon_fresnel_Callback(hObject, eventdata, handles)
% hObject    handle to recon_fresnel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.holo_lbox,'string');
if isempty(items)
    return
end

reconps.dist=handles.parameters.dist;
reconps.center=handles.parameters.center;
reconps.b=handles.parameters.b;
reconps.MN2=handles.parameters.MN2;
reconps.dxy2o=handles.parameters.dxy2o;
reconps.dxy2=handles.parameters.dxy2;

[recons,hwp,reconps]=recon_window('userdata','digitalholography','holograms',handles.holograms,...
    'hwp',handles.hwp,'reconps',reconps);

if isempty(findobj('type','figure','tag','dh'))
    return
end

if ~isempty(hwp) && ~isempty(reconps) && ~isempty(recons)
    handles.hwp=hwp;
    items=fieldnames(reconps);
    for n=1:length(items)
        handles.parameters.(items{n})=reconps.(items{n});
    end
    items=fieldnames(recons);
    for n=1:length(items)
        handles.reconstructions(1).(items{n})=recons(1).(items{n});
        handles.reconstructions(2).(items{n})=recons(2).(items{n});
    end
    
    items=sort(fieldnames(handles.reconstructions));
    set(handles.recon_lbox,'string',items,'value',1);
    set(handles.file_save,'enable','on');
    set(handles.file_saveas,'enable','on');
    guidata(hObject,handles)
end


% --------------------------------------------------------------------
function phase_menu_Callback(hObject, eventdata, handles)
% hObject    handle to phase_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function phase_gpm_Callback(hObject, eventdata, handles)
% hObject    handle to phase_gpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.recon_lbox,'string');
if isempty(items)
    return
end
gpmps.mag=handles.parameters.mag;
gpmps.dalpha=handles.parameters.dalpha;
gpmps.dbeta=handles.parameters.dbeta;
gpmps.alpha=handles.parameters.alpha;
gpmps.beta=handles.parameters.beta;

[phasemaps,gpmps]=gpm_window('userdata','digitalholography','reconstructions',handles.reconstructions,'parameters',gpmps);

if isempty(findobj('type','figure','tag','dh'))
    return
end

if ~isempty(phasemaps)
    items=fieldnames(phasemaps);
    for n=1:length(items)
        handles.phasemaps(1).(items{n})=phasemaps(1).(items{n});
        handles.phasemaps(2).(items{n})=phasemaps(2).(items{n});
        handles.phasemaps(3).(items{n})=phasemaps(3).(items{n});
        handles.phasemaps(4).(items{n})=phasemaps(4).(items{n});
    end
    items=sort(fieldnames(handles.phasemaps));
    set(handles.phase_lbox,'string',items,'value',1);
    
    items=fieldnames(gpmps);
    for n=1:length(items)
        handles.parameters.(items{n})=gpmps.(items{n});
    end
    set(handles.file_save,'enable','on');
    set(handles.file_saveas,'enable','on');
    guidata(hObject,handles)
end


% --------------------------------------------------------------------
function phase_ddfilter_Callback(hObject, eventdata, handles)
% hObject    handle to phase_ddfilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.phase_lbox,'string');
if isempty(items)
    return
end

phasemaps=ddfilter_window('userdata','digitalholography',...
    'phasemaps',handles.phasemaps);

if isempty(findobj('type','figure','tag','dh'))
    return
end

if ~isempty(phasemaps)
    handles.phasemaps=phasemaps;
    set(handles.file_save,'enable','on');
    set(handles.file_saveas,'enable','on');
    guidata(hObject,handles)
end


% --------------------------------------------------------------------
function phase_mifilter_Callback(hObject, eventdata, handles)
% hObject    handle to phase_mifilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.phase_lbox,'string');
if isempty(items)
    return
end

phasemaps=mifilter_window('userdata','digitalholography',...
    'phasemaps',handles.phasemaps);

if isempty(findobj('type','figure','tag','dh'))
    return
end

if ~isempty(phasemaps)
    items=fieldnames(phasemaps);
    for n=1:length(items)
        handles.phasemaps(1).(items{n})=phasemaps(1).(items{n});
    end
    set(handles.file_save,'enable','on');
    set(handles.file_saveas,'enable','on');
    guidata(hObject,handles)
end


% --------------------------------------------------------------------
function phase_wscfilter_Callback(hObject, eventdata, handles)
% hObject    handle to phase_wscfilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.phase_lbox,'string');
if isempty(items)
    return
end

phasemaps=wscfilter_window('userdata','digitalholography',...
    'phasemaps',handles.phasemaps);

if isempty(findobj('type','figure','tag','dh'))
    return
end

if ~isempty(phasemaps)
    items=fieldnames(phasemaps);
    for n=1:length(items)
        handles.phasemaps(1).(items{n})=phasemaps(1).(items{n});
    end
    set(handles.file_save,'enable','on');
    set(handles.file_saveas,'enable','on');
    guidata(hObject,handles)
end


% --------------------------------------------------------------------
function phase_iscfilter_Callback(hObject, eventdata, handles)
% hObject    handle to phase_iscfilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.phase_lbox,'string');
if isempty(items)
    return
end

phasemaps=iscfilter_window('userdata','digitalholography',...
    'phasemaps',handles.phasemaps);

if isempty(findobj('type','figure','tag','dh'))
    return
end

if ~isempty(phasemaps)
    items=fieldnames(phasemaps);
    for n=1:length(items)
        handles.phasemaps(1).(items{n})=phasemaps(1).(items{n});
    end
    set(handles.file_save,'enable','on');
    set(handles.file_saveas,'enable','on');
    guidata(hObject,handles)
end


% --------------------------------------------------------------------
function phase_adfilter_Callback(hObject, eventdata, handles)
% hObject    handle to phase_adfilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.phase_lbox,'string');
if isempty(items)
    return
end

phasemaps=adfilter_window('userdata','digitalholography',...
    'phasemaps',handles.phasemaps);

if isempty(findobj('type','figure','tag','dh'))
    return
end

if ~isempty(phasemaps)
    items=fieldnames(phasemaps);
    for n=1:length(items)
        handles.phasemaps(1).(items{n})=phasemaps(1).(items{n});
    end
    set(handles.file_save,'enable','on');
    set(handles.file_saveas,'enable','on');
    guidata(hObject,handles)
end


% --------------------------------------------------------------------
function phase_objregion_Callback(hObject, eventdata, handles)
% hObject    handle to phase_objregion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.phase_lbox,'string');
if isempty(items)
    return
end

phasemaps=orm_window('userdata','digitalholography',...
    'phasemaps',handles.phasemaps);

if isempty(findobj('type','figure','tag','dh'))
    return
end

if ~isempty(phasemaps)
    handles.phasemaps=phasemaps;
    set(handles.file_save,'enable','on');
    set(handles.file_saveas,'enable','on');
    guidata(hObject,handles)
end


% --- Executes on button press in upm_load.
function upm_load_Callback(hObject, eventdata, handles)
% hObject    handle to upm_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.mat','All MAT-Files(*.mat)'},'Load Data');
% If "Cancel" is selected then return
if isequal([filename,pathname],[0,0])
    return
    % Otherwise construct the fullfilename and Check and load the file.
else
    File = fullfile(pathname,filename);
    % if the MAT-file is not valid, do not save the name
    if Check_And_Load(File,handles,{'upm'});
        set(handles.file_save,'enable','on');
        set(handles.file_saveas,'enable','on');
    end
end


% --- Executes on button press in upm_save.
function upm_save_Callback(hObject, eventdata, handles)
% hObject    handle to upm_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile( {'*.mat';'*.*'}, 'Save');
if isequal([filename,pathname],[0,0])
    return
else
    File = fullfile(pathname,filename);
end
Save_Data(File,handles,{'upm'});


% --- Executes on button press in upm_delete.
function upm_delete_Callback(hObject, eventdata, handles)
% hObject    handle to upm_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.upm_lbox,'string');
if isempty(items)
    return
end
index=get(handles.upm_lbox,'value');

handles.upm=rmfield(handles.upm,items(index));
items(index)=[];
set(handles.upm_lbox,'value',1);
set(handles.upm_lbox,'string',items);

set(handles.file_save,'enable','on')
set(handles.file_saveas,'enable','on')

guidata(hObject,handles)


% --- Executes on button press in upm_disp.
function upm_disp_Callback(hObject, eventdata, handles)
% hObject    handle to upm_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index=get(handles.upm_lbox,'value');
upmstr=get(handles.upm_lbox,'string');
if isempty(upmstr)
    index=[];
end
for n=index
    figname=['Unwrapped Phase Maps: ',upmstr{n}];
    figure('numbertitle','off','name',figname,'userdata','digitalholography')
    opticimage(handles.upm(1).(upmstr{n}),handles.upm(2).(upmstr{n}).dxy2(1),...
        handles.upm(2).(upmstr{n}).dxy2(2),handles.upm(2).(upmstr{n}).center);
end


% --- Executes during object creation, after setting all properties.
function upm_lbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upm_lbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in upm_lbox.
function upm_lbox_Callback(hObject, eventdata, handles)
% hObject    handle to upm_lbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns upm_lbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from upm_lbox
showinfo(hObject,handles);
if strcmp(get(handles.dh,'SelectionType'),'open')
    upm_disp_Callback(handles.upm_disp, [], handles);
end


% --------------------------------------------------------------------
function phase_rgunwrap_Callback(hObject, eventdata, handles)
% hObject    handle to phase_rgunwrap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.phase_lbox,'string');
if isempty(items)
    return
end
index=get(handles.phase_lbox,'value');

items(index)=[];

phasemaps=handles.phasemaps;
phasemaps=rmfield(phasemaps,items);

phasemaps=rgunwrap_window('userdata','digitalholography','phasemaps',phasemaps);

if isempty(findobj('type','figure','tag','dh'))
    return
end

if ~isempty(phasemaps)
    items=fieldnames(phasemaps);
    for n=1:length(items)
        handles.upm(1).(items{n})=phasemaps(1).(items{n});
        handles.upm(2).(items{n})=phasemaps(2).(items{n});
        handles.upm(3).(items{n})=phasemaps(3).(items{n});
        handles.upm(4).(items{n})=phasemaps(4).(items{n});
    end
    items=sort(fieldnames(handles.upm));
    set(handles.upm_lbox,'string',items,'value',1);
    set(handles.file_save,'enable','on');
    set(handles.file_saveas,'enable','on');
    guidata(hObject,handles)
end


% --------------------------------------------------------------------
function phase_lcunwrap_Callback(hObject, eventdata, handles)
% hObject    handle to phase_lcunwrap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.phase_lbox,'string');
if isempty(items)
    return
end
index=get(handles.phase_lbox,'value');

items(index)=[];

phasemaps=handles.phasemaps;
phasemaps=rmfield(phasemaps,items);

phasemaps=rcunwrap_window('userdata','digitalholography','phasemaps',phasemaps);

if isempty(findobj('type','figure','tag','dh'))
    return
end

if ~isempty(phasemaps)
    items=fieldnames(phasemaps);
    for n=1:length(items)
        handles.upm(1).(items{n})=phasemaps(1).(items{n});
        handles.upm(2).(items{n})=phasemaps(2).(items{n});
        handles.upm(3).(items{n})=phasemaps(3).(items{n});
        handles.upm(4).(items{n})=phasemaps(4).(items{n});
    end
    items=sort(fieldnames(handles.upm));
    set(handles.upm_lbox,'string',items,'value',1);
    set(handles.file_save,'enable','on');
    set(handles.file_saveas,'enable','on');
    guidata(hObject,handles)
end


% --------------------------------------------------------------------
function showinfo(hObject,handles)
% Show the information of the data
items=get(hObject,'string');
index=get(hObject,'value');
if isempty(items) || length(index)>1
    return
end
infoname=cell(3,1);
infovalue=cell(3,1);

switch hObject
    case handles.holo_lbox
        infoname{1}='Data type:';
        infoname{2}='Name:';
        infovalue{1}='Hologram';
        infovalue{2}=items{index};
        infoname{3}='Size:';
        infovalue{3}=['[',num2str(size(handles.holograms.(items{index}))),']'];
        handles.cdtype='holograms';
        handles.cdname=items{index};
    case handles.recon_lbox
        infoname{1}='Data type:';
        infoname{2}='Name:';
        infovalue{1}='Reconstruction';
        infovalue{2}=items{index};
        infoname{3}='Size:';
        datasize=size(handles.reconstructions(1).(items{index}));
        if isequal(datasize,handles.reconstructions(2).(items{index}).MN2)
            infovalue{3}=['[',num2str(datasize),']'];
        else
            infovalue{3}='error';
        end
        infoname{4}='Recon distance:';
        infovalue{4}=['[',num2str(handles.reconstructions(2).(items{index}).dist),'] mm'];
        infoname{5}='Image center:';
        infovalue{5}=['[',num2str(handles.reconstructions(2).(items{index}).center),'] mm'];
        infoname{6}='Resolution:';
        infovalue{6}=['[',num2str(handles.reconstructions(2).(items{index}).dxy2o),'] mm'];
        infoname{7}='R/SD:';
        infovalue{7}=['[',num2str(handles.reconstructions(2).(items{index}).b),']'];
        infoname{8}='Sampling Dist:';
        infovalue{8}=['[',num2str(handles.reconstructions(2).(items{index}).dxy2),'] mm'];
        handles.cdtype='reconstructions';
        handles.cdname=items{index};
    case handles.phase_lbox
        infoname{1}='Data type:';
        infoname{2}='Name:';
        infovalue{1}='Phasemap';
        infovalue{2}=items{index};
        infoname{3}='Size:';
        datasize1=size(handles.phasemaps(1).(items{index}));
        datasize2=size(handles.phasemaps(3).(items{index}).weight);
        if isequal(datasize1,datasize2,handles.phasemaps(2).(items{index}).MN2)
            infovalue{3}=['[',num2str(datasize1),']'];
        else
            infovalue{3}='error';
        end
        infoname{4}='Recon distance:';
        infovalue{4}=['[',num2str(handles.phasemaps(2).(items{index}).dist),'] mm'];
        infoname{5}='Image center:';
        infovalue{5}=['[',num2str(handles.phasemaps(2).(items{index}).center),'] mm'];
        infoname{6}='Resolution:';
        infovalue{6}=['[',num2str(handles.phasemaps(2).(items{index}).dxy2o),'] mm'];
        infoname{7}='R/SD:';
        infovalue{7}=['[',num2str(handles.phasemaps(2).(items{index}).b),']'];
        infoname{8}='Sampling Dist:';
        infovalue{8}=['[',num2str(handles.phasemaps(2).(items{index}).dxy2),'] mm'];
        infoname{9}='';
        infovalue{9}='';
        infoname{10}='Delta alpha:';
        infovalue{10}=[num2str(handles.phasemaps(3).(items{index}).dalpha),' rad'];
        infoname{11}='Delta beta:';
        infovalue{11}=[num2str(handles.phasemaps(3).(items{index}).dbeta),' rad'];
        infoname{12}='Alpha:';
        infovalue{12}=[num2str(handles.phasemaps(3).(items{index}).alpha.*180./pi),' deg'];
        infoname{13}='Beta:';
        infovalue{13}=[num2str(handles.phasemaps(3).(items{index}).beta.*180./pi),' deg'];
        infoname{14}='CAP:';
        infovalue{14}=num2str(handles.phasemaps(3).(items{index}).cap);
        infoname{15}='Magnification:';
        infovalue{15}=num2str(handles.phasemaps(3).(items{index}).mag);
        infoname{16}='Obtained from:';
        str=handles.phasemaps(3).(items{index}).reconname{1};
        if length(handles.phasemaps(3).(items{index}).reconname)>1
            str=[str,',',handles.phasemaps(3).(items{index}).reconname{2}];
        end
        infovalue{16}=str;
        infoname{17}='Object region:';
        if ~isempty(handles.phasemaps(4).(items{index}))
            infovalue{17}=['[',num2str(size(handles.phasemaps(4).(items{index}))),'] logical'];
        else
            infovalue{17}='empty';
        end
        handles.cdtype='phasemaps';
        handles.cdname=items{index};
    case handles.upm_lbox
        infoname{1}='Data type:';
        infoname{2}='Name:';
        infovalue{1}='Unwrapped phasemap';
        infovalue{2}=items{index};
        infoname{3}='Size:';
        datasize1=size(handles.upm(1).(items{index}));
        datasize2=size(handles.upm(3).(items{index}).weight);
        if isequal(datasize1,datasize2,handles.upm(2).(items{index}).MN2)
            infovalue{3}=['[',num2str(datasize1),']'];
        else
            infovalue{3}='error';
        end
        infoname{4}='Recon distance:';
        infovalue{4}=['[',num2str(handles.upm(2).(items{index}).dist),'] mm'];
        infoname{5}='Image center:';
        infovalue{5}=['[',num2str(handles.upm(2).(items{index}).center),'] mm'];
        infoname{6}='Resolution:';
        infovalue{6}=['[',num2str(handles.upm(2).(items{index}).dxy2o),'] mm'];
        infoname{7}='R/SD:';
        infovalue{7}=['[',num2str(handles.upm(2).(items{index}).b),']'];
        infoname{8}='Sampling Dist:';
        infovalue{8}=['[',num2str(handles.upm(2).(items{index}).dxy2),'] mm'];
        infoname{9}='';
        infovalue{9}='';
        infoname{10}='Delta alpha:';
        infovalue{10}=[num2str(handles.upm(3).(items{index}).dalpha),' rad'];
        infoname{11}='Delta beta:';
        infovalue{11}=[num2str(handles.upm(3).(items{index}).dbeta),' rad'];
        infoname{12}='Alpha:';
        infovalue{12}=[num2str(handles.upm(3).(items{index}).alpha.*180./pi),' deg'];
        infoname{13}='Beta:';
        infovalue{13}=[num2str(handles.upm(3).(items{index}).beta.*180./pi),' deg'];
        infoname{14}='CAP:';
        infovalue{14}=num2str(handles.upm(3).(items{index}).cap);
        infoname{15}='Magnification:';
        infovalue{15}=num2str(handles.upm(3).(items{index}).mag);
        infoname{16}='Obtained from:';
        str=handles.upm(3).(items{index}).reconname{1};
        if length(handles.upm(3).(items{index}).reconname)>1
            str=[str,',',handles.upm(3).(items{index}).reconname{2}];
        end
        infovalue{16}=str;
        infoname{17}='Object region:';
        if ~isempty(handles.upm(4).(items{index}))
            infovalue{17}=['[',num2str(size(handles.upm(4).(items{index}))),'] logical'];
        else
            infovalue{17}='empty';
        end
        handles.cdtype='upm';
        handles.cdname=items{index};
end

for n=1:length(infovalue)
    infovalue{n}(27:end)=[];
end
set(handles.infoname_text,'string',infoname);
set(handles.infovalue_text,'string',infovalue);

guidata(hObject, handles);


% --------------------------------------------------------------------
function surface_menu_Callback(hObject, eventdata, handles)
% hObject    handle to surface_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function surface_mesh_Callback(hObject, eventdata, handles)
% hObject    handle to surface_mesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index=get(handles.upm_lbox,'value');
upmstr=get(handles.upm_lbox,'string');
if isempty(upmstr)
    index=[];
end
for n=index
    figname=['3-D surface mesh: ',upmstr{n}];
    figure('numbertitle','off','name',figname,'userdata','digitalholography')
    C=-2.*pi./handles.hwp.lambda.*1e6.*...
        (sqrt(1-cos(handles.upm(3).(upmstr{n}).alpha+handles.upm(3).(upmstr{n}).dalpha).^2-cos(handles.upm(3).(upmstr{n}).beta+handles.upm(3).(upmstr{n}).dbeta).^2)-...
        sqrt(1-cos(handles.upm(3).(upmstr{n}).alpha).^2-cos(handles.upm(3).(upmstr{n}).beta).^2));
    if isempty(C)
        C=1;
    end
    height=handles.upm(1).(upmstr{n})./C;
    [vx,vy]=opticimage(handles.upm(2).(upmstr{n}).MN2,handles.upm(2).(upmstr{n}).dxy2(1).*handles.upm(3).(upmstr{n}).mag,...
        handles.upm(2).(upmstr{n}).dxy2(2).*handles.upm(3).(upmstr{n}).mag,handles.upm(2).(upmstr{n}).center.*handles.upm(3).(upmstr{n}).mag);
    mesh(vx,vy,height),axis equal
    xlabel('x(mm)'),ylabel('y (mm)'),zlabel('height (mm)')
end


% --------------------------------------------------------------------
function file_imwrite_Callback(hObject, eventdata, handles)
% hObject    handle to file_imwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.cdtype)||isempty(handles.cdname)
    return
end
[filename, pathname] = uiputfile( ...
    {'*.tif', 'TIFF-images (*.tif)'; ...
    '*.bmp', 'bitmap-images (*.bmp)'; ...
    '*.jpg', 'JPEG-images (*.jpg)';}, ...
    'Write data to image');

if ~isequal([filename,pathname],[0,0])
    if length(filename) < 5
        filename=[filename,'.tif'];
    elseif ~strcmp(filename(end-3:end),'.tif') && ~strcmp(filename(end-3:end),'.bmp') && ~strcmp(filename(end-3:end),'.jpg')
        filename=[filename,'.tif'];
    end
    switch handles.cdtype
        case 'holograms'
            imwrite(zero2one(abs(handles.(handles.cdtype).(handles.cdname))),[pathname,filename]);
        case 'reconstructions'
            imwrite(zero2one(abs(handles.(handles.cdtype)(1).(handles.cdname))),[pathname,filename]);
        otherwise
            imwrite(zero2one(handles.(handles.cdtype)(1).(handles.cdname)),[pathname,filename]);
    end
end



% --------------------------------------------------------------------
function hololbox_cm_Callback(hObject, eventdata, handles)
% hObject    handle to hololbox_cm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function holorename_Callback(hObject, eventdata, handles)
% hObject    handle to holorename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.holo_lbox,'string');
if isempty(items)
    return
end
index=get(handles.holo_lbox,'value');

if length(index)>1
    return
end

answer = inputdlg('Pleanse enter the name:','Rename',1,items(index));

if isempty(answer)
    return
end
if strcmp(answer,items(index))
    return
end

handles.holograms.(answer{1})=handles.holograms.(items{index});
handles.holograms=rmfield(handles.holograms,items(index));

set(handles.holo_lbox,'string',sort(fieldnames(handles.holograms)))
set(handles.holo_lbox,'value',1);

set(handles.file_save,'enable','on')
set(handles.file_saveas,'enable','on')

guidata(hObject,handles)


% --------------------------------------------------------------------
function reconlbox_cm_Callback(hObject, eventdata, handles)
% hObject    handle to reconlbox_cm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function reconrename_Callback(hObject, eventdata, handles)
% hObject    handle to reconrename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.recon_lbox,'string');
if isempty(items)
    return
end
index=get(handles.recon_lbox,'value');

if length(index)>1
    return
end

answer = inputdlg('Pleanse enter the name:','Rename',1,items(index));

if isempty(answer)
    return
end
if strcmp(answer,items(index))
    return
end

for n=1:length(handles.reconstructions)
    handles.reconstructions(n).(answer{1})=handles.reconstructions(n).(items{index});
end
handles.reconstructions=rmfield(handles.reconstructions,items(index));

set(handles.recon_lbox,'string',sort(fieldnames(handles.reconstructions)))
set(handles.recon_lbox,'value',1);

set(handles.file_save,'enable','on')
set(handles.file_saveas,'enable','on')

guidata(hObject,handles)


% --------------------------------------------------------------------
function phaselbox_cm_Callback(hObject, eventdata, handles)
% hObject    handle to phaselbox_cm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function phaserename_Callback(hObject, eventdata, handles)
% hObject    handle to phaserename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.phase_lbox,'string');
if isempty(items)
    return
end
index=get(handles.phase_lbox,'value');

if length(index)>1
    return
end

answer = inputdlg('Pleanse enter the name:','Rename',1,items(index));

if isempty(answer)
    return
end
if strcmp(answer,items(index))
    return
end

for n=1:length(handles.phasemaps)
    handles.phasemaps(n).(answer{1})=handles.phasemaps(n).(items{index});
end
handles.phasemaps=rmfield(handles.phasemaps,items(index));

set(handles.phase_lbox,'string',sort(fieldnames(handles.phasemaps)))
set(handles.phase_lbox,'value',1);

set(handles.file_save,'enable','on')
set(handles.file_saveas,'enable','on')

guidata(hObject,handles)


% --------------------------------------------------------------------
function upmlbox_cm_Callback(hObject, eventdata, handles)
% hObject    handle to upmlbox_cm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function upmrename_Callback(hObject, eventdata, handles)
% hObject    handle to upmrename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
items=get(handles.upm_lbox,'string');
if isempty(items)
    return
end
index=get(handles.upm_lbox,'value');

if length(index)>1
    return
end

answer = inputdlg('Pleanse enter the name:','Rename',1,items(index));

if isempty(answer)
    return
end
if strcmp(answer,items(index))
    return
end

for n=1:length(handles.upm)
    handles.upm(n).(answer{1})=handles.upm(n).(items{index});
end
handles.upm=rmfield(handles.upm,items(index));

set(handles.upm_lbox,'string',sort(fieldnames(handles.upm)))
set(handles.upm_lbox,'value',1);

set(handles.file_save,'enable','on')
set(handles.file_saveas,'enable','on')

guidata(hObject,handles)


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function dh_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to dh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close dh.
function dh_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to dh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% Check if the work is saved
svd=get(handles.file_save,'enable');
if strcmp(svd,'on')
    selection = questdlg('Work not saved, do you want to save?','Exit Digital Holography','Yes','No','Cancel','Yes');
    switch selection
        case 'Yes'
            file_save_Callback(handles.file_save, eventdata, handles);
            if strcmp(get(handles.file_save,'enable'),'on')
                return
            end
        case 'Cancel'
            return
        case ''
            return
    end
end
subwindows=findobj('type','figure','userdata','digitalholography');
delete(subwindows);
delete(handles.dh)


