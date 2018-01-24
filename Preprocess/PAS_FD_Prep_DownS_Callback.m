% --------------------------------------------------------------------
%  PAS_FD_Prep_DownS_Callback(hObject,eventdata,handles)
%  ���ݽ�����
% --------------------------------------------------------------------
function PAS_FD_Prep_DownS_Callback(hObject,eventdata,handles)
% hObject    handle to PAS_FD_Prep_Common (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��������ѡ��
dnl=1;
[inl,valuel]=listdlg('Name','������ѡ��','PromptString','ѡ��Ԥ�ﵽ�Ĳ�����','SelectionMode',...
    'Multiple','ListString',{'����ֵ','��ʱֵ','����ֵ'},...
    'InitialValue',dnl,'ListSize',[200 150]);
if valuel==0
    return;
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

j2NFZ=0;%����ͳ��ѡ�е������ݲ�����Ҫ��δ������ļ�����
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
    ODL=length(num2str(timet(1)));
    if any(inl==1)%��ȡ����ֵ
        if ODL==10%��ʱֵ
            CXS=100;
        elseif ODL==12%����ֵ
            CXS=10000;
        elseif ODL==14%��ֵ
            CXS=1000000;
        else
            j2NFZ=j2NFZ+1;
            continue;
        end
        ind=mod(timet,CXS)==0;
        dataz=dataz(ind);
        timet=timet(ind)/CXS;
        %���
        f_nn=find(FF=='.')-1;
        outname=strcat(Pname,FF(1:f_nn),'_DSday','.txt');
        fm=['%8i %.5f\n'];
        fidof=fopen(outname,'wt');
        fprintf(fidof,fm,[timet';dataz']);
        fclose(fidof);
    end
    if any(inl==2)%��ȡ��ʱֵ
        if ODL==12%����ֵ
            CXS=100;
        elseif ODL==14%��ֵ
            CXS=10000;
        else
            j2NFZ=j2NFZ+1;
            continue;
        end
        ind=mod(timet,CXS)==0;
        dataz=dataz(ind);
        timet=timet(ind)/CXS;
        %���
        f_nn=find(FF=='.')-1;
        outname=strcat(Pname,FF(1:f_nn),'_DSday','.txt');
        fm=['%10i %.5f\n'];
        fidof=fopen(outname,'wt');
        fprintf(fidof,fm,[timet';dataz']);
        fclose(fidof);
    end
    if any(inl==3)%��ȡ����ֵ
        if ODL==14%��ֵ
            CXS=100;
        else
            j2NFZ=j2NFZ+1;
            continue;
        end
        ind=mod(timet,CXS)==0;
        dataz=dataz(ind);
        timet=timet(ind)/CXS;
        %���
        f_nn=find(FF=='.')-1;
        outname=strcat(Pname,FF(1:f_nn),'_DSday','.txt');
        fm=['%12i %.5f\n'];
        fidof=fopen(outname,'wt');
        fprintf(fidof,fm,[timet';dataz']);
        fclose(fidof);
    end
    waitbar(iiNFZ/NFZ,hw);
end
close(hw);
ttu=toc/60;
strtmp=['ѡ��',num2str(NFZ),'���ļ�������',num2str(j2NFZ),'���ļ��������ݲ�����Ҫ��δ���д���',...
    '�������ļ�������',Pname,'�� �ļ�����׺Ϊ_DS*.txt������ʱ',num2str(ttu),'����'];
msgbox(strtmp,'�������');