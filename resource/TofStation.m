function varargout = TofStation(varargin)
% TOFSTATION MATLAB code for TofStation.fig
%      TOFSTATION, by itself, creates a new TOFSTATION or raises the existing
%      singleton*.
%
%      H = TOFSTATION returns the handle to a new TOFSTATION or the handle to
%      the existing singleton*.
%
%      TOFSTATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TOFSTATION.M with the given input arguments.
%
%      TOFSTATION('Property','Value',...) creates a new TOFSTATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TofStation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TofStation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TofStation

% Last Modified by GUIDE v2.5 15-Jun-2016 18:21:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @TofStation_OpeningFcn, ...
    'gui_OutputFcn',  @TofStation_OutputFcn, ...
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

% --- Executes just before TofStation is made visible.
function TofStation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TofStation (see VARARGIN)

% Choose default command line output for TofStation
handles.output = hObject;
movegui('center');
% Update handles structure
guidata(hObject, handles);
load('station.mat');
pathStation=which('station.mat');
ff=find(pathStation=='.',1,'last');
copyfile(pathStation,[pathStation(1:ff-1),'-Backup.mat']);
DATAinC=table2cell(table(TZDM,CDBH,TZM,FLDM,FLM,JWD(:,1),JWD(:,2),FWJ,GC));
DATAsc={};
set(handles.uitable1,'Data',DATAinC);
handles.DATAinC=DATAinC;
handles.DATAsc=DATAsc;
handles.flagCX=0;%û�н��в�ѯ����
handles.px12=1;
handles.px4=1;
handles.px6=1;
handles.px7=1;
handles.px8=1;
handles.px9=1;
guidata(hObject,handles);
% UIWAIT makes TofStation wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = TofStation_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ܺ�����-��ʼ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% --- Executes on button press in ButtonCXTJ.
%¼���²�����Ϣ���ú���
function ButtonCXTJ_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonCXTJ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TextLRtzdm=get(handles.LRtzdm,'String');%̨վ����
TextLRcdbh=get(handles.LRcdbh,'String');%�����
TextLRtzm=get(handles.LRtzm,'String');%̨վ��
TextLRfldm=get(handles.LRfldm,'String');%��������
TextLRflm=get(handles.LRflm,'String');%������
TextLRjd=get(handles.LRjd,'String');%����
TextLRwd=get(handles.LRwd,'String');%γ��
TextLRfwj=get(handles.LRfwj,'String');%��λ��
TextLRgc=get(handles.LRgc,'String');%�߳�
TJ=[{TextLRtzdm},{TextLRcdbh},{TextLRtzm},{TextLRfldm},{TextLRflm},...
    {str2double(TextLRjd)},{str2double(TextLRwd)},{str2double(TextLRfwj)},{str2double(TextLRgc)}];
LRhh=str2num(get(handles.LRhh,'String'));
tmpdata=get(handles.uitable1,'Data');
if isempty(LRhh)
    DATAxs=[tmpdata;TJ];
else
    DATAxs=[tmpdata(1:LRhh-1,:);TJ;tmpdata(LRhh:end,:)];
end
set(handles.uitable1,'Data',DATAxs);

%OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% --- Executes on button press in ButtonCXCX.
%������Ϣ��ѯ���ú���
function ButtonCXCX_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonCXCX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.flagCX==1%��ѯ�Ժ��ٴβ�ѯ����Ҫ����֮ǰ���еĲ���
    DATAinCt=[get(handles.uitable1,'Data');handles.DATAcy];
else
    DATAinCt=get(handles.uitable1,'Data');
end
index=any(cellfun(@isempty,DATAinCt),2);
DATAinCt(index,:)=[];%��Ϣ��ȫ�����޳�

TextCXtzdm=get(handles.CXtzdm,'String');%̨վ����
TextCXcdbh=get(handles.CXcdbh,'String');%�����
TextCXtzm=get(handles.CXtzm,'String');%̨վ��
TextCXfldm=get(handles.CXfldm,'String');%��������
TextCXflm=get(handles.CXflm,'String');%������
TextCXjd=get(handles.CXjd,'String');%����
TextCXwd=get(handles.CXwd,'String');%γ��
TextCXfwj=get(handles.CXfwj,'String');%��λ��
TextCXgc=get(handles.CXgc,'String');%�߳�

ind=[1:1:size(DATAinCt,1)]';
if ~isempty(TextCXtzdm)%��ѯ����1
    tzdm=cell2mat(DATAinCt(:,1));
    inn=setdiff(1:length(TextCXtzdm),union(strfind(TextCXtzdm,'��'),strfind(TextCXtzdm,'?')));
    ind1=strmatch(TextCXtzdm(inn),tzdm(:,inn));
else
    ind1=ind;
end
if ~isempty(TextCXcdbh)%��ѯ����2
    cdbh=cell2mat(DATAinCt(:,2));
    ind2=strmatch(TextCXcdbh,cdbh);
else
    ind2=ind;
end
if ~isempty(TextCXtzm)%��ѯ����3
    %tzm=cell2mat(DATAinCt(:,3));
    %ind3=strmatch(TextCXtzm,tzm(:,1:length(TextCXtzm)));
    aa=strfind(DATAinCt(:,3),TextCXtzm);
    aa=~cellfun(@isempty,aa(:,1));
    ind3=ind(aa);
else
    ind3=ind;
end
if ~isempty(TextCXfldm)%��ѯ����4
    fldm=cell2mat(DATAinCt(:,4));
    inn=setdiff(1:length(TextCXfldm),union(strfind(TextCXfldm,'��'),strfind(TextCXfldm,'?')));
    ind4=strmatch(TextCXfldm(inn),fldm(:,inn));
else
    ind4=ind;
end
if ~isempty(TextCXflm)%��ѯ����5
    %flm=cell2mat(DATAinCt(:,5));
    %ind5=strmatch(TextCXflm,flm(:,1:length(TextCXflm)));
    aa=strfind(DATAinCt(:,5),TextCXflm);
    aa=~cellfun(@isempty,aa(:,1));
    ind5=ind(aa);
else
    ind5=ind;
end
if ~isempty(TextCXjd)%��ѯ����6
    jd=cell2mat(DATAinCt(:,6));
    aa=find(TextCXjd=='.');
    if isempty(aa)%����
        ws=0;
    else
        len=length(TextCXjd);
        ws=len-aa;%С��λ��
    end
    jd=round(jd*10^ws)/10^ws;
    ind6=ind(jd==str2num(TextCXjd));
else
    ind6=ind;
end
if ~isempty(TextCXwd)%��ѯ����7
    wd=cell2mat(DATAinCt(:,7));
    aa=find(TextCXwd=='.');
    if isempty(aa)%����
        ws=0;
    else
        len=length(TextCXwd);
        ws=len-aa;%С��λ��
    end
    wd=round(wd*10^ws)/10^ws;
    ind7=ind(wd==str2num(TextCXwd));
else
    ind7=ind;
end
if ~isempty(TextCXfwj)%��ѯ����8
    fwj=cell2mat(DATAinCt(:,8));
    aa=find(TextCXfwj=='.');
    if isempty(aa)%����
        ws=0;
    else
        len=length(TextCXfwj);
        ws=len-aa;%С��λ��
    end
    fwj=round(fwj*10^ws)/10^ws;
    ind8=ind(fwj==str2num(TextCXfwj));
else
    ind8=ind;
end
if ~isempty(TextCXgc)%��ѯ����9
    gc=cell2mat(DATAinCt(:,9));
    aa=find(TextCXgc=='.');
    if isempty(aa)%����
        ws=0;
    else
        len=length(TextCXgc);
        ws=len-aa;%С��λ��
    end
    gc=round(gc*10^ws)/10^ws;
    ind9=ind(gc==str2num(TextCXgc));
else
    ind9=ind;
end
indu=intersect(intersect(intersect(intersect(intersect(intersect(intersect(intersect(ind1,ind2),ind3),ind4),ind5),ind6),ind7),ind8),ind9);

DATAxs=DATAinCt(indu,:);
set(handles.uitable1,'Data',DATAxs);
if length(indu)<length(ind)
    handles.flagCX=1;
    handles.DATAcy=DATAinCt(setdiff(ind,indu),:);
else
    handles.flagCX=0;
    handles.DATAcy={};
end
guidata(handles.figure1,handles);

%OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% --- Executes on button press in ButtonDRCSB.
%����ϵͳ��ʼ����ú���
function ButtonDRCSB_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonDRCSB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DATAxs=handles.DATAinC;
set(handles.uitable1,'Data',DATAxs);
handles.flagCX=0;
guidata(handles.figure1,handles);

%OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% --- Executes on button press in ButtonEXIT.
%ֱ���˳����ú���
function ButtonEXIT_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonEXIT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1);

%OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% --- Executes on button press in ButtonSChh.
%ɾ��ָ���е��ú���
function ButtonSChh_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonSChh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DATAxs=get(handles.uitable1,'Data');
nhh=str2num(get(handles.SChh,'String'));%ɾ���к�
DATAsc=handles.DATAsc;
DATAsc=[DATAsc;DATAxs(nhh,:)];
handles.DATAsc=DATAsc;
DATAxs(nhh,:)=[];
set(handles.uitable1,'Data',DATAxs);
guidata(handles.figure1,handles);

%OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% --- Executes on button press in ButtonHHhh.
%�ָ���ɾ�е��ú���
function ButtonHHhh_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonHHhh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DATAsc=handles.DATAsc;
if ~isempty(DATAsc)
    nhh=str2num(get(handles.SChh,'String'));%ɾ���к�
    tmpdata=get(handles.uitable1,'Data');
    if isempty(nhh)
        DATAxs=[tmpdata;DATAsc(end,:)];
    else
        DATAxs=[tmpdata(1:nhh-1,:);DATAsc(end,:);tmpdata(nhh:end,:)];
    end
    set(handles.uitable1,'Data',DATAxs);
    DATAsc(end,:)=[];
    handles.DATAsc=DATAsc;
    guidata(handles.figure1,handles);
end

%OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% --- Executes on button press in ButtonGXXT.
%����ϵͳ������Ϣ����ú���
function ButtonGXXT_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonGXXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.flagCX==1%��ѯ�Ժ󱣴棬��Ҫ����δ��ʾ�Ĳ���ҲҪ����
    DATAoutc=[get(handles.uitable1,'Data');handles.DATAcy];
else
    DATAoutc=get(handles.uitable1,'Data');
end
index=any(cellfun(@isempty,DATAoutc),2);
DATAoutc(index,:)=[];%��Ϣ��ȫ�����޳�
%%%%%%%%%%%%%%%%%%%%%%
%����Ƿ����ظ���Ŀ
datatmp=cell2mat([DATAoutc(:,1:2),DATAoutc(:,4)]);
[~,~,uc]=unique(datatmp,'rows');
bb=tabulate(uc);
tmp=bb((bb(:,2)~=1),1);
if isempty(tmp)
    pathStation=which('station.mat');
    TZDM=strvcat(DATAoutc(:,1));
    CDBH=strvcat(DATAoutc(:,2));
    TZM=strvcat(DATAoutc(:,3));
    FLDM=strvcat(DATAoutc(:,4));
    FLM=strvcat(DATAoutc(:,5));
    JWD=cell2mat(DATAoutc(:,6:7));
    FWJ=cell2mat(DATAoutc(:,8));
    GC=cell2mat(DATAoutc(:,9));
    [SFLDM,inSF]=unique(FLDM,'rows');
    SFLM=FLM(inSF,:);
    [STZDM,inST]=unique(TZDM,'rows');
    STZM=TZM(inST,:);
    save(pathStation,'TZDM','CDBH','TZM','FLDM','FLM','JWD','FWJ','GC','SFLDM','SFLM','STZDM','STZM');
    close(handles.figure1);
else
    warndlg('���ظ���Ŀ�����ȸ������ٸ���ϵͳ��','�ظ�����');
    xh=[];
    for ii=1:1:length(tmp)
        xh=[xh;find(uc==tmp(ii))];
    end
    DATAxs=DATAoutc(xh,:);
    set(handles.uitable1,'Data',DATAxs);
    ind=[1:1:size(DATAoutc,1)]';
    if length(xh)<size(DATAoutc,1)
        handles.flagCX=1;
        handles.DATAcy=DATAoutc(setdiff(ind,xh),:);
    end
    guidata(handles.figure1,handles);
end

%OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% --- Executes on button press in ButtonEscz.
%���������Excel���ú���
function ButtonEscz_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonEscz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.flagCX==1%��ѯ�Ժ󱣴棬��Ҫ����δ��ʾ�Ĳ���ҲҪ����
    DATAoutc=[get(handles.uitable1,'Data');handles.DATAcy];
else
    DATAoutc=get(handles.uitable1,'Data');
end
index=any(cellfun(@isempty,DATAoutc),2);
DATAoutc(index,:)=[];%��Ϣ��ȫ�����޳�
%%%%%%%%%%%%%%%%%%%%%%
%����Ƿ����ظ���Ŀ
datatmp=cell2mat([DATAoutc(:,1:2),DATAoutc(:,4)]);
[~,~,uc]=unique(datatmp,'rows');
bb=tabulate(uc);
tmp=bb((bb(:,2)~=1),1);
if isempty(tmp)
    [FileName,PathName]=uiputfile({'*.xls';'*.xlsx'},'�����Ϣ��Ϊ');
    if FileName~=0
        tname=[PathName,FileName];
        delete(tname);
        Cname={'̨վ����','�����','̨վ��','��������','������','����','γ��','��λ��','�߳�'};
        xlswrite(tname,Cname,['A',num2str(1),':',char('A'+length(Cname)-1),num2str(1)]);
        xlswrite(tname,DATAoutc,['A',num2str(2),':',char('A'+length(Cname)-1),num2str(1+size(DATAoutc,1))]);
        msgbox('�����ϣ�');
    end
else
    warndlg('���ظ���Ŀ�����ȸ������������','�ظ�����');
    xh=[];
    for ii=1:1:length(tmp)
        xh=[xh;find(uc==tmp(ii))];
    end
    DATAxs=DATAoutc(xh,:);
    set(handles.uitable1,'Data',DATAxs);
    ind=[1:1:size(DATAoutc,1)]';
    if length(xh)<size(DATAoutc,1)
        handles.flagCX=1;
        handles.DATAcy=DATAoutc(setdiff(ind,xh),:);
    end
    guidata(handles.figure1,handles);
end

%OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% --- Executes on button press in ButtonEscxs.
%��ʾ�������Excel���ú���
function ButtonEscxs_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonEscxs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DATAsc=get(handles.uitable1,'Data');
index=any(cellfun(@isempty,DATAsc),2);
DATAsc(index,:)=[];%��Ϣ��ȫ�����޳�
%%%%%%%%%%%%%%%%%%%%%%
%����Ƿ����ظ���Ŀ
datatmp=cell2mat([DATAsc(:,1:2),DATAsc(:,4)]);
[~,~,uc]=unique(datatmp,'rows');
bb=tabulate(uc);
tmp=bb((bb(:,2)~=1),1);
if isempty(tmp)
    [FileName,PathName]=uiputfile({'*.xls';'*.xlsx'},'�����Ϣ��Ϊ');
    if FileName~=0
        tname=[PathName,FileName];
        delete(tname);
        Cname={'̨վ����','�����','̨վ��','��������','������','����','γ��','��λ��','�߳�'};
        xlswrite(tname,Cname,['A',num2str(1),':',char('A'+length(Cname)-1),num2str(1)]);
        xlswrite(tname,DATAsc,['A',num2str(2),':',char('A'+length(Cname)-1),num2str(1+size(DATAsc,1))]);
        msgbox('�����ϣ�');
    end
else
    warndlg('���ظ���Ŀ�����ȸ������������','�ظ�����');
    xh=[];
    for ii=1:1:length(tmp)
        xh=[xh;find(uc==tmp(ii))];
    end
    DATAxs=DATAsc(xh,:);
    set(handles.uitable1,'Data',DATAxs);
    ind=[1:1:size(DATAsc,1)]';
    if length(xh)<size(DATAsc,1)
        handles.flagCX=1;
        handles.DATAcy=[DATAsc(setdiff(ind,xh),:);handles.DATAcy];
    end
    guidata(handles.figure1,handles);
end

%OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% --- Executes on button press in ButtonEdrzj.
%����Excel��׷�ӵ���ʾ��β
function ButtonEdrzj_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonEdrzj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName]=uigetfile({'*.xls';'*.xlsx'},'�����Ϣ��Ϊ');
if FileName~=0
    tname=[PathName,FileName];
    Cname={'̨վ����','�����','̨վ��','��������','������','����','γ��','��λ��','�߳�'};
    [~,~,rawdata]=xlsread(tname,1);%��excel��1��sheet
    %���ҹؼ���Ϣ��Ӧ�к�
    Cindex=NaN(1,length(Cname));
    for ii=1:1:length(Cname)
        TmpCkey=Cname{ii};
        for jj=1:1:size(rawdata,2)
            Tmpstr=rawdata{1,jj};
            if length(Tmpstr)>=length(TmpCkey)
                if strcmp(TmpCkey,Tmpstr(1:length(TmpCkey)))
                    Cindex(ii)=jj;
                    break;
                end
            end
        end
    end
    if isnan(sum(Cindex))
        errordlg('ԭ�ļ��������������ȱ�У�');
    else
        DATAzj=rawdata(2:end,Cindex);
        DATAzj(:,1)=cellfun(@num2str,DATAzj(:,1),repmat({'%05d'},size(DATAzj,1),1),'uniformoutput',false);
        DATAzj(:,2)=cellstr(cellfun(@num2str,DATAzj(:,2)));
        DATAzj(:,4)=cellfun(@num2str,DATAzj(:,4),'uniformoutput',false);
        DATAxs=[get(handles.uitable1,'Data');DATAzj];
        set(handles.uitable1,'Data',DATAxs);
    end
end

%OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
% --- Executes on button press in ButtonEdrfg.
%����Excel������ԭ��
function ButtonEdrfg_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonEdrfg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName]=uigetfile({'*.xls';'*.xlsx'},'�����Ϣ��Ϊ');
if FileName~=0
    tname=[PathName,FileName];
    Cname={'̨վ����','�����','̨վ��','��������','������','����','γ��','��λ��','�߳�'};
    [~,~,rawdata]=xlsread(tname,1);%��excel��1��sheet
    %���ҹؼ���Ϣ��Ӧ�к�
    Cindex=NaN(1,length(Cname));
    for ii=1:1:length(Cname)
        TmpCkey=Cname{ii};
        for jj=1:1:size(rawdata,2)
            Tmpstr=rawdata{1,jj};
            if length(Tmpstr)>=length(TmpCkey)
                if TmpCkey==Tmpstr(1:length(TmpCkey))
                    Cindex(ii)=jj;
                end
            end
        end
    end
    if isnan(sum(Cindex))
        errordlg('ԭ�ļ��������������ȱ�У�');
    else
        DATAxs=rawdata(2:end,Cindex);
        DATAxs(:,1)=cellfun(@num2str,DATAxs(:,1),repmat({'%05d'},size(DATAxs,1),1),'uniformoutput',false);
        DATAxs(:,2)=cellstr(cellfun(@num2str,DATAxs(:,2)));
        DATAxs(:,4)=cellfun(@num2str,DATAxs(:,4),'uniformoutput',false);
        set(handles.uitable1,'Data',DATAxs);
        handles.flagCX=0;
        guidata(handles.figure1,handles);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ܺ�����-��ֹ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ϵͳ�Խ�������-��ʼ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function LRtzdm_Callback(hObject, eventdata, handles)
% hObject    handle to LRtzdm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LRtzdm as text
%        str2double(get(hObject,'String')) returns contents of LRtzdm as a double

% --- Executes during object creation, after setting all properties.
function LRtzdm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LRtzdm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LRcdbh_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function LRcdbh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LRcdbh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LRtzm_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function LRtzm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LRtzm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LRfldm_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function LRfldm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LRfldm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LRflm_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function LRflm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LRflm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LRjd_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function LRjd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LRjd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LRwd_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function LRwd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LRwd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LRfwj_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function LRfwj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LRfwj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LRgc_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function LRgc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LRgc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LRhh_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function LRhh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LRhh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function SChh_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function SChh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SChh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CXtzdm_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CXtzdm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CXtzdm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CXtzm_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CXtzm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CXtzm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CXfldm_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CXfldm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CXfldm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CXflm_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CXflm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CXflm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CXjd_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CXjd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CXjd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CXwd_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CXwd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CXwd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CXfwj_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CXfwj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CXfwj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CXgc_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CXgc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CXgc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CXcdbh_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CXcdbh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CXcdbh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ϵͳ�Խ�������-����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��������-��ʼ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in ButtonSort12.
function ButtonSort12_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonSort12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DATAxs=get(handles.uitable1,'Data');
px12=handles.px12;
[~,ind]=sortrows(DATAxs,[1,2]*px12);
DATAxs=DATAxs(ind,:);
set(handles.uitable1,'Data',DATAxs);
handles.px12=px12*(-1);
guidata(handles.figure1,handles);


% --- Executes on button press in ButtonSort4.
function ButtonSort4_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonSort4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DATAxs=get(handles.uitable1,'Data');
px4=handles.px4;
[~,ind]=sortrows(DATAxs,4*px4);
DATAxs=DATAxs(ind,:);
set(handles.uitable1,'Data',DATAxs);
handles.px4=px4*(-1);
guidata(handles.figure1,handles);

% --- Executes on button press in ButtonSort6.
function ButtonSort6_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonSort6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DATAxs=get(handles.uitable1,'Data');
px6=handles.px6;
[~,ind]=sortrows(DATAxs,6*px6);
DATAxs=DATAxs(ind,:);
set(handles.uitable1,'Data',DATAxs);
handles.px6=px6*(-1);
guidata(handles.figure1,handles);

% --- Executes on button press in ButtonSort7.
function ButtonSort7_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonSort7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DATAxs=get(handles.uitable1,'Data');
px7=handles.px7;
[~,ind]=sortrows(DATAxs,7*px7);
DATAxs=DATAxs(ind,:);
set(handles.uitable1,'Data',DATAxs);
handles.px7=px7*(-1);
guidata(handles.figure1,handles);

% --- Executes on button press in ButtonSort8.
function ButtonSort8_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonSort8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DATAxs=get(handles.uitable1,'Data');
px8=handles.px8;
[~,ind]=sortrows(DATAxs,8*px8);
DATAxs=DATAxs(ind,:);
set(handles.uitable1,'Data',DATAxs);
handles.px8=px8*(-1);
guidata(handles.figure1,handles);

% --- Executes on button press in ButtonSort9.
function ButtonSort9_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonSort9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DATAxs=get(handles.uitable1,'Data');
px9=handles.px9;
[~,ind]=sortrows(DATAxs,9*px9);
DATAxs=DATAxs(ind,:);
set(handles.uitable1,'Data',DATAxs);
handles.px9=px9*(-1);
guidata(handles.figure1,handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��������-����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%