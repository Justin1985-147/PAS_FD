% --------------------------------------------------------------------
%  PAS_FD_Tide_OnlyFRosegh_Callback(hObject, eventdata, handles)
%  ���Ƴ�ϫ����õ��ͼ
% --------------------------------------------------------------------
function PAS_FD_Tide_OnlyFRosegh_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Tide_FRosegh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
depNew=struct('date1','','date2','','JG','1');
prompt={'õ��ͼ������ʼʱ��','õ��ͼ������ֹʱ��','���Ƽ����ԭ������������'};
titleinput='��������'; lines=1; option.resize='on';option.windowstyle='normal';
hi=inputdlg(prompt,titleinput,lines,struct2cell(depNew),option);
if isempty(hi)
    return;
end
fields={'date1','date2','JG'};
if size(hi,1)>0 depNew=cell2struct(hi,fields,1); end

%���ļ���
[Fname,Pname]=uigetfile({'*Rose.mat','mat�ļ�(*Rose.mat)'},'����ѡ��ϫõ��ͼ����ļ�','MultiSelect','on');
%�����ļ�·��
if iscell(Fname)
    NFZ=length(Fname);
elseif Fname==0  %���û�д��ļ�������������
    return;
else
    NFZ=1;
    Fname={Fname};
end

for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];
    load(dbfile);
    if isempty(depNew.date1)
        tm1=timej(1);   
    else
        tm1=str2num(depNew.date1);
    end
    if isempty(depNew.date2)
        tm2=timej(end);
    else
        tm2=str2num(depNew.date2);
    end
    RoseGraph(FactorZ,timej,fa0,tname,Pname,FF,tm1,tm2,str2num(depNew.JG));
end
end