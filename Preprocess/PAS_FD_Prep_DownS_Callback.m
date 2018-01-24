% --------------------------------------------------------------------
%  PAS_FD_Prep_DownS_Callback(hObject,eventdata,handles)
%  数据降采样
% --------------------------------------------------------------------
function PAS_FD_Prep_DownS_Callback(hObject,eventdata,handles)
% hObject    handle to PAS_FD_Prep_Common (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%处理类型选择
dnl=1;
[inl,valuel]=listdlg('Name','采样率选择','PromptString','选择预达到的采样率','SelectionMode',...
    'Multiple','ListString',{'整日值','整时值','分钟值'},...
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

j2NFZ=0;%用来统计选中但因数据不符合要求，未处理的文件个数
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
    ODL=length(num2str(timet(1)));
    if any(inl==1)%抽取整日值
        if ODL==10%整时值
            CXS=100;
        elseif ODL==12%分钟值
            CXS=10000;
        elseif ODL==14%秒值
            CXS=1000000;
        else
            j2NFZ=j2NFZ+1;
            continue;
        end
        ind=mod(timet,CXS)==0;
        dataz=dataz(ind);
        timet=timet(ind)/CXS;
        %输出
        f_nn=find(FF=='.')-1;
        outname=strcat(Pname,FF(1:f_nn),'_DSday','.txt');
        fm=['%8i %.5f\n'];
        fidof=fopen(outname,'wt');
        fprintf(fidof,fm,[timet';dataz']);
        fclose(fidof);
    end
    if any(inl==2)%抽取整时值
        if ODL==12%分钟值
            CXS=100;
        elseif ODL==14%秒值
            CXS=10000;
        else
            j2NFZ=j2NFZ+1;
            continue;
        end
        ind=mod(timet,CXS)==0;
        dataz=dataz(ind);
        timet=timet(ind)/CXS;
        %输出
        f_nn=find(FF=='.')-1;
        outname=strcat(Pname,FF(1:f_nn),'_DSday','.txt');
        fm=['%10i %.5f\n'];
        fidof=fopen(outname,'wt');
        fprintf(fidof,fm,[timet';dataz']);
        fclose(fidof);
    end
    if any(inl==3)%抽取分钟值
        if ODL==14%秒值
            CXS=100;
        else
            j2NFZ=j2NFZ+1;
            continue;
        end
        ind=mod(timet,CXS)==0;
        dataz=dataz(ind);
        timet=timet(ind)/CXS;
        %输出
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
strtmp=['选中',num2str(NFZ),'个文件，其中',num2str(j2NFZ),'个文件由于数据不符合要求未进行处理，',...
    '处理后的文件保存在',Pname,'， 文件名后缀为_DS*.txt，共耗时',num2str(ttu),'分钟'];
msgbox(strtmp,'处理完毕');