% --------------------------------------------------------------------
%  PAS_FD_Prep_Trunc_Callback(hObject,eventdata,handles)
%  ��ȡָ��ʱ�䷶Χ�ڵ�����
% --------------------------------------------------------------------
function PAS_FD_Prep_Trunc_Callback(hObject,eventdata,handles)
% hObject    handle to PAS_FD_Prep_Common (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�����趨
depfw=struct('xmi','NaN','xma','NaN');
prompt={'��ʼʱ��','��ֹʱ��'};
title='ѡ��ʱ�䷶Χ��ȡ����(NaNΪ���޶�)'; resize='off';
hi=inputdlg(prompt,title,[1 100],struct2cell(depfw),resize);
if isempty(hi)
    return;
end
fields={'xmi','xma'};
if size(hi,1)>0 depfw=cell2struct(hi,fields,1); end
fwcs=[str2num(depfw.xmi),str2num(depfw.xma)];
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
    lent=length(num2str(timet(1)));
    if isnan(fwcs(1))
        instart=1;
    else
        ss=length(num2str(fwcs(1)));
        tmp=fwcs(1);
        if ss>=lent
            tmp1=str2num(tmp(1:lent));
            instart=find(timet>=tmp1,1,'first');
            if isempty(instart)
                instart=1;
            end
        else
            instart=find(timet>=tmp*10^(lent-ss),1,'first');
        end
    end
    if isnan(fwcs(2))
        inend=length(timet);
    else
        ee=length(num2str(fwcs(2)));
        tmp=fwcs(2);
        if ee>=lent
            tmp1=str2num(tmp(1:lent));
            inend=find(timet<=tmp1,1,'last');
            if isempty(inend)
                inend=length(timet);
            else
                inend=length(timet)-inend+1;
            end
        else
            inend=find(timet<(tmp+1)*10^(lent-ee),1,'last');
        end
    end
    %%%%%%%%%%%%%%
    %���
    f_nn=find(FF=='.')-1;
    outname=strcat(Pname,FF(1:f_nn),'_JD','.txt');
    fm=['%',num2str(length(num2str(timet(1)))),'i %.5f\n'];
    fidof=fopen(outname,'wt');
    fprintf(fidof,fm,[timet(instart:inend)';dataz(instart:inend)']);
    fclose(fidof);
    waitbar(iiNFZ/NFZ,hw);
end
close(hw);
ttu=toc/60;
strtmp=['ѡ��',num2str(NFZ),'���ļ�������',num2str(j2NFZ),'���ļ����ڲ�����������δ���д���',...
    '�������ļ�������',Pname,'�� �ļ�����׺Ϊ_JD.txt������ʱ',num2str(ttu),'����'];
msgbox(strtmp,'�������');