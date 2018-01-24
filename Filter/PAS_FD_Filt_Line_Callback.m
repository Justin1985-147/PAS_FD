% --------------------------------------------------------------------
%  PAS_FD_Filt_Line_Callback(hObject, eventdata, handles)
%  线性滤波器，包括别尔采夫滤波器
% --------------------------------------------------------------------
function PAS_FD_Filt_Line_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Filt_Line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%处理类型选择
dnl=[1];
[inl,valuel]=listdlg('Name','线性滤波器','PromptString','选择进行的滤波处理','SelectionMode',...
    'Multiple','ListString',{'别尔采夫滤波'},...
    'InitialValue',dnl,'ListSize',[200 150]);
if valuel==0
    return;
end
depCS=struct('QS','999999');
prompt={'缺数标记'};
titleinput='基本参数'; lines=1; resize='on';
hi=inputdlg(prompt,titleinput,lines,struct2cell(depCS),resize);
if length(hi)<1
    return;
end
QS=str2double(hi{1});
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
j3NFZ=0;%用来统计选中但因数据时间不是整点等原因，未处理的文件个数
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
        if length(num2str(timet(1)))~=10
            j3NFZ=j3NFZ+1;
            continue;
        end
    end
    %%%%%%%%%%%%%%
    %处理
    if sum(inl==1)%别尔采夫滤波,之前要求做过填补断数处理
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
strtmp=['选中',num2str(NFZ),'个文件，其中',num2str(j2NFZ),'个文件由于不是两列数据未进行处理，',...
    num2str(j3NFZ),'个文件由于数据时间不是整点等原因未进行处理，'...
    '滤波处理后的数据已经按默认文件名保存完毕，',...
    '处理后的文件保存在',Pname,'， 其中-BRFf.txt是别尔采夫瞬时零漂值，-BRFr.txt是去除零漂后的结果'];
msgbox(strtmp,'处理完毕');
end