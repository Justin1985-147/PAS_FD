% --------------------------------------------------------------------
%  PAS_FD_Prep_Common_Callback(hObject, eventdata, handles)
%  ����Ԥ����-���洦������������ȫ,ȱ����ֵ,ȥ̨��,ȥͻ��
% --------------------------------------------------------------------
function PAS_FD_Prep_Common_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Prep_Common (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��������ѡ��
dnl=3;
[inl,valuel]=listdlg('Name','����Ԥ����','PromptString','ѡ����еĴ���','SelectionMode',...
    'Single','ListString',{'������','������������','�����������㡢ȥͻ��','����������ֵ','�����������㡢��ֵ','�����������㡢ȥͻ������ֵ'},...
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
if inl==2||inl==3||inl==5||inl==6%ȥ̨��
    dn2=1;
    [in2,value2]=listdlg('Name','ȥ̨��(���Ȼ������)','PromptString','ѡ����Ҫ�Ĺ�������','SelectionMode',...
        'Single','ListString',{'ȫ������','�����','�¹���','�չ���'},...
        'InitialValue',dn2,'ListSize',[200 150]);
    if value2==0
        return;
    end
end
if inl==4||inl==5||inl==6%ȱ����ֵ
    dn4=4;
    [in4,value4]=listdlg('Name','ȱ����ֵ(���Ȼ������)','PromptString','ѡ����Ҫ�Ĳ�ֵ����','SelectionMode',...
        'Single','ListString',{'���ڵ��ֵ����������','���Բ�ֵ��������','�ֶ�3�β�ֵ��1�׵�������','3��������ֵ��2�׵�������'},...
        'InitialValue',dn4,'ListSize',[200 150]);
    if value4==0
        return;
    end
end
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
hw=waitbar(0,'Ԥ������...','Name',['��',num2str(NFZ),'���ļ�']);
tic;%��ʼ��ʱ
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
    end
    %%%%%%%%%%%%%%
    %����
    if inl==1%������
        [dataz,timet]=FillGap(dataz,timet,QS);
    elseif inl==2%������������
        [dataz,timet]=FillGap(dataz,timet,QS);
        [dataz,~]=EraStep(dataz,timet,QS,in2,0);
    elseif inl==3%�����������㡢ȥͻ��
        [dataz,timet]=FillGap(dataz,timet,QS);
        dataz=EraDoubleS(dataz,timet,QS,in2);
    elseif inl==4%����������ֵ
        [dataz,timet]=FillGap(dataz,timet,QS);
        [dataz,~]=RepInvalid(dataz,QS,in4);
    elseif inl==5%�����������㡢��ֵ
        [dataz,timet]=FillGap(dataz,timet,QS);
        [dataz,~]=EraStep(dataz,timet,QS,in2,0);
        [dataz,~]=RepInvalid(dataz,QS,in4);
    elseif inl==6%�����������㡢ȥͻ������ֵ
        [dataz,timet]=FillGap(dataz,timet,QS);
        dataz=EraDoubleS(dataz,timet,QS,in2);
        [dataz,~]=RepInvalid(dataz,QS,in4);
    else
        return;
    end
    %%%%%%%%%%%%%%
    %���
    f_nn=find(FF=='.')-1;
    outname=strcat(Pname,FF(1:f_nn),'_PrepCn','.txt');
    fm=['%',num2str(length(num2str(timet(1)))),'i %.5f\n'];
    fidof=fopen(outname,'wt');
    fprintf(fidof,fm,[timet';dataz']);
    fclose(fidof);
    waitbar(iiNFZ/NFZ,hw);
end
close(hw);
ttu=toc/60;
strtmp=['ѡ��',num2str(NFZ),'���ļ�������',num2str(j2NFZ),'���ļ����ڲ�����������δ���д���',...
    '�������ļ�������',Pname,'�� �ļ�����׺Ϊ_PrepCn.txt������ʱ',num2str(ttu),'����'];
msgbox(strtmp,'�������');