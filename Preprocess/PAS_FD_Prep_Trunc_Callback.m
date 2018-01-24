% --------------------------------------------------------------------
%  PAS_FD_Prep_Trunc_Callback(hObject,eventdata,handles)
%  截取指定时间范围内的数据
% --------------------------------------------------------------------
function PAS_FD_Prep_Trunc_Callback(hObject,eventdata,handles)
% hObject    handle to PAS_FD_Prep_Common (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%参数设定
depfw=struct('xmi','NaN','xma','NaN');
prompt={'起始时间','终止时间'};
title='选定时间范围截取数据(NaN为不限定)'; resize='off';
hi=inputdlg(prompt,title,[1 100],struct2cell(depfw),resize);
if isempty(hi)
    return;
end
fields={'xmi','xma'};
if size(hi,1)>0 depfw=cell2struct(hi,fields,1); end
fwcs=[str2num(depfw.xmi),str2num(depfw.xma)];
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

j2NFZ=0;%用来统计选中但因数据列数不符合要求，未处理的文件个数
hw=waitbar(0,'预处理中...','Name',['共',num2str(NFZ),'个文件']);
tic;%开始计时
for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];
    FF=Fname{iiNFZ};
    tmp=load(dbfile); [~,N]=size(tmp);
    %如果不是两列数据，则跳过文件
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
    %输出
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
strtmp=['选中',num2str(NFZ),'个文件，其中',num2str(j2NFZ),'个文件由于不是两列数据未进行处理，',...
    '处理后的文件保存在',Pname,'， 文件名后缀为_JD.txt，共耗时',num2str(ttu),'分钟'];
msgbox(strtmp,'处理完毕');