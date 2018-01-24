% --------------------------------------------------------------------
%  PAS_FD_Tide_SpeAzi_Callback(hObject, eventdata, handles)
%  �ɳ�ϫõ��������ָ����λ��ϫ����
% --------------------------------------------------------------------
function PAS_FD_Tide_SpeAzi_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Tide_FRosegh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dep=struct('FWJ','0,10,360');
prompt={'�����Ƴ�ϫ���ӵ���㣬������յ㷽λ��'};
titleinput='��������'; lines=1; option.resize='on';option.windowstyle='normal';
hi=inputdlg(prompt,titleinput,lines,struct2cell(dep),option);
if isempty(hi)
    return;
end
fields={'FWJ'};
if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
%���ļ���
[FFname,PPname]=uigetfile({'*Rose.mat','mat�ļ�(*Rose.mat)'},'����ѡ��ϫõ��ͼ����ļ�','MultiSelect','on');
%�����ļ�·��
if iscell(FFname)
    NFZ=length(FFname);
elseif FFname==0  %���û�д��ļ�������������
    return;
else
    NFZ=1;
    FFname={FFname};
end

hfa=str2num(dep.FWJ);
for iiNFZ=1:1:NFZ
    dbfile=[PPname,FFname{iiNFZ}];
    load(dbfile);
    for hfa0=hfa(1):hfa(2):hfa(3)
        STideFactor(fa0,FactorZ,MsfZ,timej,hfa0,PPname,FFname{iiNFZ},tname); 
    end  
end
end