function varargout = pas_fd_main(varargin)
% PAS_FD_MAIN MATLAB code for pas_fd_main.fig
%      PAS_FD_MAIN, by itself, creates a new PAS_FD_MAIN or raises the existing
%      singleton*.
%
%      H = PAS_FD_MAIN returns the handle to a new PAS_FD_MAIN or the handle to
%      the existing singleton*.
%
%      PAS_FD_MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PAS_FD_MAIN.M with the given input arguments.
%
%      PAS_FD_MAIN('Property','Value',...) creates a new PAS_FD_MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pas_fd_main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pas_fd_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pas_fd_main

% Last Modified by GUIDE v2.5 16-Oct-2015 23:49:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pas_fd_main_OpeningFcn, ...
                   'gui_OutputFcn',  @pas_fd_main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before pas_fd_main is made visible.
function pas_fd_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pas_fd_main (see VARARGIN)
movegui('center')
% Choose default command line output for pas_fd_main
handles.output = hObject;
handles.canshu=PAS_FD_CheckPZ(hObject, eventdata, handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pas_fd_main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pas_fd_main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function PAS_FD_Plots_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PAS_FD_Preprocess_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Preprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PAS_FD_Abnormality_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Abnormality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PAS_FD_Tide_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Tide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PAS_FD_Filter_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PAS_FD_SuBat_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_SuBat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PAS_FD_Other_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Other (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PAS_FD_Help_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PAS_FD_Help_CopyRight_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Help_CopyRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CopyRight;


% --------------------------------------------------------------------
function PAS_FD_SuBat_Meet_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_SuBat_Meet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PAS_FD_Exit_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rmpath(genpath(pwd));
close all;
