% --------------------------------------------------------------------
%  PAS_FD_Filt_Line_Callback(hObject, eventdata, handles)
%  �����˲�������������ɷ��˲���
% --------------------------------------------------------------------
function PAS_FD_Filt_Line_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Filt_Line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%��������ѡ��
dnl=[1];
[inl,valuel]=listdlg('Name','�����˲���','PromptString','ѡ����е��˲�����','SelectionMode',...
    'Multiple','ListString',{'����ɷ��˲�'},...
    'InitialValue',dnl,'ListSize',[200 150]);
if valuel==0
    return;
end
depCS=struct('QS','999999');
prompt={'ȱ�����'};
titleinput='��������'; lines=1; resize='on';
hi=inputdlg(prompt,titleinput,lines,struct2cell(depCS),resize);
if length(hi)<1
    return;
end
QS=str2double(hi{1});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ļ���
[Fname,Pname]=uigetfile({'*.txt','txt�ļ�(*.txt)';'*.dat','dat�ļ�(*.dat)';'*.*','���з���Ҫ����ļ�(*.*)'},'����ѡ��������ļ�','MultiSelect','on');
%�����ļ�·��
if iscell(Fname)
    NFZ=length(Fname);
elseif Fname==0  %���û�д��ļ�������������
    return;
else
    NFZ=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if NFZ==1%һ���ļ�
    Fname={Fname};
end

j2NFZ=0;%����ͳ��ѡ�е�����������������Ҫ��δ������ļ�����
j3NFZ=0;%����ͳ��ѡ�е�������ʱ�䲻�������ԭ��δ������ļ�����
for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];
    FF=Fname{iiNFZ};
    tmp=load(dbfile); [~,N]=size(tmp);
    %��������������ݣ��������ļ�
    if N~=2
        j2NFZ=j2NFZ+1;
        continue;
    else
        dataz=tmp(:,2);    timet=tmp(:,1);
        if length(num2str(timet(1)))~=10
            j3NFZ=j3NFZ+1;
            continue;
        end
    end
    %%%%%%%%%%%%%%
    %����
    if sum(inl==1)%����ɷ��˲�,֮ǰҪ���������������
        [yf,yr]=BrcfFilter(dataz,QS);
        f_nn=find(FF=='.')-1;
        outnamef=strcat(Pname,FF(1:f_nn),'-BRFf','.txt');
        outnamer=strcat(Pname,FF(1:f_nn),'-BRFr','.txt');
        fm=strcat('%10i %.5f\n');
        fidof=fopen(outnamef,'wt');
        fprintf(fidof,fm,[timet';yf']);
        fclose(fidof);
        fidor=fopen(outnamer,'wt');
        fprintf(fidor,fm,[timet';yr']);
        fclose(fidor);
    end
    %%%%%%%%%%%%%%
end
strtmp=['ѡ��',num2str(NFZ),'���ļ�������',num2str(j2NFZ),'���ļ����ڲ�����������δ���д���',...
    num2str(j3NFZ),'���ļ���������ʱ�䲻�������ԭ��δ���д���'...
    '�˲������������Ѿ���Ĭ���ļ���������ϣ�',...
    '�������ļ�������',Pname,'�� ����-BRFf.txt�Ǳ���ɷ�˲ʱ��Ưֵ��-BRFr.txt��ȥ����Ư��Ľ��'];
msgbox(strtmp,'�������');
end