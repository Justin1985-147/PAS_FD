function varargout = CopyRight(varargin)
% PAS_GUI_WELCOME MATLAB code for pas_gui_welcome.fig
%      PAS_GUI_WELCOME, by itself, creates a new PAS_GUI_WELCOME or raises the existing
%      singleton*.
%
%      H = PAS_GUI_WELCOME returns the handle to a new PAS_GUI_WELCOME or the handle to
%      the existing singleton*.
%
%      PAS_GUI_WELCOME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PAS_GUI_WELCOME.M with the given input arguments.
%
%      PAS_GUI_WELCOME('Property','Value',...) creates a new PAS_GUI_WELCOME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pas_gui_welcome_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pas_gui_welcome_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pas_gui_welcome

% Last Modified by GUIDE v2.5 25-Aug-2014 02:38:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CopyRight_OpeningFcn, ...
                   'gui_OutputFcn',  @CopyRight_OutputFcn, ...
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


% --- Executes just before pas_gui_welcome is made visible.
function CopyRight_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pas_gui_welcome (see VARARGIN)
movegui('center')
pic1=imread('earth4.jpg');
axes(handles.axes1);
image(pic1);
axis off;
pic2=imread('banner.jpg');
axes(handles.axes2);
image(pic2);
axis off;
% Choose default command line output for pas_gui_welcome
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pas_gui_welcome wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CopyRight_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;
