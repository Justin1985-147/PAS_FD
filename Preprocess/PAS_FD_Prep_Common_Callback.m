% --------------------------------------------------------------------
%  PAS_FD_Prep_Common_Callback(hObject, eventdata, handles)
%  数据预处理-常规处理：包括断数补全,缺数插值,去台阶,去突跳
% --------------------------------------------------------------------
function PAS_FD_Prep_Common_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Prep_Common (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%处理类型选择
dnl=3;
[inl,valuel]=listdlg('Name','常规预处理','PromptString','选择进行的处理','SelectionMode',...
    'Single','ListString',{'补断数','补断数、归零','补断数、归零、去突跳','补断数、插值','补断数、归零、插值','补断数、归零、去突跳、插值'},...
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
if inl==2||inl==3||inl==5||inl==6%去台阶
    dn2=1;
    [in2,value2]=listdlg('Name','去台阶(首先会填补断数)','PromptString','选择需要的归零类型','SelectionMode',...
        'Single','ListString',{'全部归零','年归零','月归零','日归零'},...
        'InitialValue',dn2,'ListSize',[200 150]);
    if value2==0
        return;
    end
end
if inl==4||inl==5||inl==6%缺数插值
    dn4=4;
    [in4,value4]=listdlg('Name','缺数插值(首先会填补断数)','PromptString','选择需要的插值方法','SelectionMode',...
        'Single','ListString',{'相邻点插值（不连续）','线性插值（连续）','分段3次插值（1阶导连续）','3次样条插值（2阶导连续）'},...
        'InitialValue',dn4,'ListSize',[200 150]);
    if value4==0
        return;
    end
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
    %处理
    if inl==1%补断数
        [dataz,timet]=FillGap(dataz,timet,QS);
    elseif inl==2%补断数、归零
        [dataz,timet]=FillGap(dataz,timet,QS);
        [dataz,~]=EraStep(dataz,timet,QS,in2,0);
    elseif inl==3%补断数、归零、去突跳
        [dataz,timet]=FillGap(dataz,timet,QS);
        dataz=EraDoubleS(dataz,timet,QS,in2);
    elseif inl==4%补断数、插值
        [dataz,timet]=FillGap(dataz,timet,QS);
        [dataz,~]=RepInvalid(dataz,QS,in4);
    elseif inl==5%补断数、归零、插值
        [dataz,timet]=FillGap(dataz,timet,QS);
        [dataz,~]=EraStep(dataz,timet,QS,in2,0);
        [dataz,~]=RepInvalid(dataz,QS,in4);
    elseif inl==6%补断数、归零、去突跳、插值
        [dataz,timet]=FillGap(dataz,timet,QS);
        dataz=EraDoubleS(dataz,timet,QS,in2);
        [dataz,~]=RepInvalid(dataz,QS,in4);
    else
        return;
    end
    %%%%%%%%%%%%%%
    %输出
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
strtmp=['选中',num2str(NFZ),'个文件，其中',num2str(j2NFZ),'个文件由于不是两列数据未进行处理，',...
    '处理后的文件保存在',Pname,'， 文件名后缀为_PrepCn.txt，共耗时',num2str(ttu),'分钟'];
msgbox(strtmp,'处理完毕');