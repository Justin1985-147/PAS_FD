% --------------------------------------------------------------------
%  PAS_FD_Tide_Check_Callback(hObject, eventdata, handles)
%  ͨ�����߼��Լ��ϵ��ѡ����
% --------------------------------------------------------------------
function PAS_FD_Tide_Check_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Tide_FRosegh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dep=struct('QS','999999','YCL','1','SCF','0.1');
prompt={'ȱ�����','0��Ԥ����1ȥ̨�׼�ͻ��','��λ��������'};
titleinput='��������'; lines=1; option.resize='on';option.windowstyle='normal';
hi=inputdlg(prompt,titleinput,lines,struct2cell(dep),option);
if isempty(hi)
    return;
end
fields={'QS','YCL','SCF'};
if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
load('Station.mat');
%���ļ���
[Fname,Pname]=uigetfile({'*.txt','txt�ļ�(*.txt)';'*.dat','dat�ļ�(*.dat)';'*.*','���з���Ҫ����ļ�(*.*)'},'����ѡ���ڼ������Ӧ���ļ�','MultiSelect','on');
%�����ļ�·��
%%%%%%%%%%%%%%
%Ĭ��matlab�ļ�����������
%%%%%%%%%%%%%%
if iscell(Fname)
    NFZ=length(Fname);
elseif Fname==0  %���û�д��ļ�������������
    return;
else
    NFZ=1;
end
if NFZ<3
    return;%�ļ�С��3�����޷����
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GS=NFZ;
BJ=0;
alldbfile={};
allkkx=[];
for iiNFZ=1:1:NFZ
    FF=Fname{iiNFZ};
    dbfile=[Pname,FF];
    cx=strmatch(FF(9:12),SFLDM);
    if length(FF)<12||isempty(cx)||(cx~=4&&cx~=5&&cx~=6&&cx~=7)%�Ƿ���Ӧ��۲�
        if BJ==3||BJ==4%��̨վ����ǰ���ļ���������Ҫ��
            %%%%%%%%%%%%%%%%%
            SelfCheckPlot(dep,alldbfile,allkkx,FWJ,TZM,FLDM);
            BJ=0;
            alldbfile={};
            allkkx=[];
            %%%%%%%%%%%%%%%%%
        end
        GS=GS-1;
        if GS+BJ<3
            break;
        else
            continue;
        end
    end
    tkkx=strmatch(strcat(FF(1:5),FF(7)),[TZDM,CDBH]);
    kkx=strmatch(FF(9:12),FLDM(tkkx,:));
    kkx=tkkx(kkx);%������station���еı��
    if isempty(kkx)
        if BJ==3||BJ==4%��̨վ����ǰ���ļ���������Ҫ��
            %%%%%%%%%%%%%%%%%
            SelfCheckPlot(dep,alldbfile,allkkx,FWJ,TZM,FLDM);
            BJ=0;
            alldbfile={};
            allkkx=[];
            %%%%%%%%%%%%%%%%%
        end
        GS=GS-1;
        if GS+BJ<3
            break;
        else
            continue;
        end
    end
    %%%%%%%%%%%%%%%%%%%
    if BJ==0%��δ����̨վ�׸�����
        tmptz=strcat(FF(1:5),FF(7));
        alldbfile={dbfile};
        BJ=1;
        allkkx=kkx;
    else%���׸�����
        if ~strcmp(tmptz,strcat(FF(1:5),FF(7)))%�ļ���Ӧ��ͬ��̨վ
            if BJ==3||BJ==4%��̨վ����ǰ���ļ���������Ҫ��
                %%%%%%%%%%%%%%%%%
                SelfCheckPlot(dep,alldbfile,allkkx,FWJ,TZM,FLDM);
                %%%%%%%%%%%%%%%%%
            end
            tmptz=strcat(FF(1:5),FF(7));
            alldbfile={dbfile};
            BJ=1;
            allkkx=kkx;
        else%ͬһ̨վ
            alldbfile=[alldbfile;{dbfile}];
            BJ=BJ+1;
            allkkx=[allkkx;kkx];
            if iiNFZ==NFZ%���һ���ļ�
                if BJ==3||BJ==4%�ļ���������Ҫ��
                    %%%%%%%%%%%%%%%%%
                    SelfCheckPlot(dep,alldbfile,allkkx,FWJ,TZM,FLDM);
                    %%%%%%%%%%%%%%%%%
                end
            end
        end
    end
    GS=GS-1;
    if GS+BJ<3
        break;
    else
        continue;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end