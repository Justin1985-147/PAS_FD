% --------------------------------------------------------------------
%  PAS_FD_Prep_Merge_Callback(hObject,eventdata,handles)
%  ��ͬ�ļ�ƴ��
%  ��Ϊ���ݿ�ʼʱ������Ϊǰ�ļ�
% --------------------------------------------------------------------
function PAS_FD_Prep_Merge_Callback(hObject,eventdata,handles)
% hObject    handle to PAS_FD_Prep_Merge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
QS=999999;%ȱ�����
%��������ѡ��
dnl=1;
[inl,valuel]=listdlg('Name','�����ļ�ƴ��','PromptString','ѡ��ƴ�ӷ�ʽ','SelectionMode',...
    'Single','ListString',{'ȥ����һ�ļ�ʱ���ص����ֺ�ƴ��','ȥ��ǰһ�ļ�ʱ���ص����ֺ�ƴ��'},...
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
j1NFZ=0;%����ͳ��ѡ�е�ʱ���ʽ��һ�£�δ������ļ�����
j2NFZ=0;%����ͳ��ѡ�е�������������һ�£�δ������ļ�����
tic;%��ʼ��ʱ
tmpdata=cell(NFZ,1);%����
NNZ=NaN(NFZ,1);%ÿ���ļ�����
RecDate=NaN(NFZ,2);%ÿ���ļ�������ֹʱ��
NumDate=NaN(NFZ,1);%ÿ���ļ�ʱ���ʽ
for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];
    FF=Fname{iiNFZ};
    tmp=load(dbfile);
    tmpdata{iiNFZ}=tmp; [~,NNZ(iiNFZ)]=size(tmp);
    RecDate(iiNFZ,1)=tmp(1,1);
    RecDate(iiNFZ,2)=tmp(end,1);
    NumDate(iiNFZ)=length(num2str(tmp(1,1)));
end

%ȥ��������һ���ļ�
[NumN,ClassN]=histcounts(NNZ,'binmethod','integers');%���в�ͬ�����ļ��ĸ���
[~,ind]=max(NumN);%�������ļ�����Ϊ��׼��������ʽ��Ϊ����������ƴ��
indNN=(ClassN(ind)+ClassN(ind+1))/2;%��׼�ļ�Ӧ�þ��е�����
ind=NNZ==indNN;
j2NFZ=length(ind)-sum(ind);
tmpdata=tmpdata(ind);
NNZ=NNZ(ind);
RecDate=RecDate(ind,:);
NumDate=NumDate(ind);
%ȥ��ʱ���ʽ��һ���ļ�
[NumN,ClassN]=histcounts(NumDate,'binmethod','integers');%���в�ͬʱ���ʽ�ļ��ĸ���
[~,ind]=max(NumN);%�������ļ�����Ϊ��׼��������ʽ��Ϊ����������ƴ��
indNN=(ClassN(ind)+ClassN(ind+1))/2;%��׼�ļ�Ӧ�þ��е�ʱ���ʽ
ind=NumDate==indNN;
j1NFZ=length(ind)-sum(ind);
tmpdata=tmpdata(ind);
NNZ=NNZ(ind);
RecDate=RecDate(ind,:);
NumDate=NumDate(ind);
%�ļ�����¼ʱ������
[~,ind]=sort(RecDate(:,1),'ascend');
tmpdata=tmpdata(ind);
RecDate=RecDate(ind,:);
%ƴ���ļ�
tmp1RecDate=RecDate(1:end-1,:);
tmp2RecDate=RecDate(2:end,:);
tmp3RecDate=[max(tmp1RecDate(:,1),tmp2RecDate(:,1)),min(tmp1RecDate(:,2),tmp2RecDate(:,2))];%�ص�����
if inl==1%ȥ����һ�ļ�ʱ���ص����ֺ�ƴ��
    tmp1=tmpdata{1};
    DateZ=tmp1(:,1);
    DataZ=tmp1(:,2:end);
    DataZ(DataZ==QS)=NaN;
    for ii=2:1:size(RecDate,1)
        tmp1=tmpdata{ii};
        indStart=find(tmp1(:,1)==tmp3RecDate(ii-1,1));
        indEnd=find(tmp1(:,1)==tmp3RecDate(ii-1,2));
        tmp1(indStart:indEnd,:)=[];
        if ~isempty(tmp1)
            DateZ=[DateZ;tmp1(:,1)];
            tmp2=tmp1(:,2:end);
            tmp2(tmp2==QS)=NaN;
            xs=[];
            for nni=1:1:size(tmp2,2)
                tmp3=DataZ(find(~isnan(DataZ(:,nni)),1,'last'),nni)-tmp2(find(~isnan(tmp2(:,nni)),1,'first'),nni);
                if isempty(tmp3)
                    tmp3=0;
                end
                xs=[xs,tmp3];
            end
            DataZ=[DataZ;tmp2+xs];
        end 
    end    
elseif inl==2%ȥ��ǰһ�ļ�ʱ���ص����ֺ�ƴ��
    tmp1=tmpdata{end};
    DateZ=tmp1(:,1);
    DataZ=tmp1(:,2:end);
    DataZ(DataZ==QS)=NaN;
    for ii=size(RecDate,1)-1:-1:1
        tmp1=tmpdata{ii};
        indStart=find(tmp1(:,1)==tmp3RecDate(ii-1,1));
        indEnd=find(tmp1(:,1)==tmp3RecDate(ii-1,2));
        tmp1(indStart:indEnd,:)=[];
        if ~isempty(tmp1)
            DateZ=[tmp1(:,1);DateZ];
            tmp2=tmp1(:,2:end);
            tmp2(tmp2==QS)=NaN;
            xs=[];
            for nni=1:1:size(tmp2,2)
                tmp3=DataZ(find(~isnan(DataZ(:,nni)),1,'first'),nni)-tmp2(find(~isnan(tmp2(:,nni)),1,'last'),nni);
                if isempty(tmp3)
                    tmp3=0;
                end
                xs=[xs,tmp3];
            end
            DataZ=[tmp2+xs;DataZ];
        end 
    end    
else
    return;
end
%%%%%%%%%%%%%%
%���
FF=Fname{1};
f_nn=find(FF=='.')-1;
outname=strcat(Pname,FF(1:f_nn),'_PJ','.txt');
fm=['%',num2str(NumDate(1)),'i',repmat(' %.5f',1,NNZ(1)-1),'\n'];
fidof=fopen(outname,'wt');
fprintf(fidof,fm,[DateZ';DataZ']);
fclose(fidof);
ttu=toc/60;
strtmp=['ѡ��',num2str(NFZ),'���ļ�������',num2str(j2NFZ),'���ļ�����������һ��δ����ƴ�ӣ�',...
    num2str(j1NFZ),'���ļ�����ʱ���ʽ��һ��δ����ƴ�ӣ��������ļ�������',Pname,'���ļ�����׺Ϊ_PJ.txt������ʱ',num2str(ttu),'����'];
msgbox(strtmp,'�������');