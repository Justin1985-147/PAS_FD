% --------------------------------------------------------------------
%  PAS_FD_Prep_Merge_Callback(hObject,eventdata,handles)
%  不同文件拼接
%  认为数据开始时间较早的为前文件
% --------------------------------------------------------------------
function PAS_FD_Prep_Merge_Callback(hObject,eventdata,handles)
% hObject    handle to PAS_FD_Prep_Merge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
QS=999999;%缺数标记
%处理类型选择
dnl=1;
[inl,valuel]=listdlg('Name','数据文件拼接','PromptString','选择拼接方式','SelectionMode',...
    'Single','ListString',{'去掉后一文件时间重叠部分后拼接','去掉前一文件时间重叠部分后拼接'},...
    'InitialValue',dnl,'ListSize',[200 150]);
if valuel==0
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%读文件名
[Fname,Pname]=uigetfile({'*.txt','txt文件(*.txt)';'*.dat','dat文件(*.dat)';'*.*','所有符合要求的文件(*.*)'},'请挑选待处理的文件','MultiSelect','on');
%完整文件路径
if iscell(Fname)
    NFZ=length(Fname);
elseif Fname==0  %如果没有打开文件，则跳出程序
    return;
else
    NFZ=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if NFZ==1%一个文件
    Fname={Fname};
end
j1NFZ=0;%用来统计选中但时间格式不一致，未处理的文件个数
j2NFZ=0;%用来统计选中但因数据列数不一致，未处理的文件个数
tic;%开始计时
tmpdata=cell(NFZ,1);%数据
NNZ=NaN(NFZ,1);%每个文件列数
RecDate=NaN(NFZ,2);%每个文件数据起止时间
NumDate=NaN(NFZ,1);%每个文件时间格式
for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];
    FF=Fname{iiNFZ};
    tmp=load(dbfile);
    tmpdata{iiNFZ}=tmp; [~,NNZ(iiNFZ)]=size(tmp);
    RecDate(iiNFZ,1)=tmp(1,1);
    RecDate(iiNFZ,2)=tmp(end,1);
    NumDate(iiNFZ)=length(num2str(tmp(1,1)));
end

%去掉列数不一致文件
[NumN,ClassN]=histcounts(NNZ,'binmethod','integers');%具有不同列数文件的个数
[~,ind]=max(NumN);%以最多的文件类型为标准，其它格式认为不符不参与拼接
indNN=(ClassN(ind)+ClassN(ind+1))/2;%标准文件应该具有的列数
ind=NNZ==indNN;
j2NFZ=length(ind)-sum(ind);
tmpdata=tmpdata(ind);
NNZ=NNZ(ind);
RecDate=RecDate(ind,:);
NumDate=NumDate(ind);
%去掉时间格式不一致文件
[NumN,ClassN]=histcounts(NumDate,'binmethod','integers');%具有不同时间格式文件的个数
[~,ind]=max(NumN);%以最多的文件类型为标准，其它格式认为不符不参与拼接
indNN=(ClassN(ind)+ClassN(ind+1))/2;%标准文件应该具有的时间格式
ind=NumDate==indNN;
j1NFZ=length(ind)-sum(ind);
tmpdata=tmpdata(ind);
NNZ=NNZ(ind);
RecDate=RecDate(ind,:);
NumDate=NumDate(ind);
%文件按记录时间排序
[~,ind]=sort(RecDate(:,1),'ascend');
tmpdata=tmpdata(ind);
RecDate=RecDate(ind,:);
%拼接文件
tmp1RecDate=RecDate(1:end-1,:);
tmp2RecDate=RecDate(2:end,:);
tmp3RecDate=[max(tmp1RecDate(:,1),tmp2RecDate(:,1)),min(tmp1RecDate(:,2),tmp2RecDate(:,2))];%重叠部分
if inl==1%去掉后一文件时间重叠部分后拼接
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
elseif inl==2%去掉前一文件时间重叠部分后拼接
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
%输出
FF=Fname{1};
f_nn=find(FF=='.')-1;
outname=strcat(Pname,FF(1:f_nn),'_PJ','.txt');
fm=['%',num2str(NumDate(1)),'i',repmat(' %.5f',1,NNZ(1)-1),'\n'];
fidof=fopen(outname,'wt');
fprintf(fidof,fm,[DateZ';DataZ']);
fclose(fidof);
ttu=toc/60;
strtmp=['选中',num2str(NFZ),'个文件，其中',num2str(j2NFZ),'个文件由于列数不一致未进行拼接，',...
    num2str(j1NFZ),'个文件由于时间格式不一致未进行拼接，处理后的文件保存在',Pname,'，文件名后缀为_PJ.txt，共耗时',num2str(ttu),'分钟'];
msgbox(strtmp,'处理完毕');