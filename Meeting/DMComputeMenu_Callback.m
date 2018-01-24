% --------------------------------------------------------------------
% 调和分析批量处理，默认计算模式
% --------------------------------------------------------------------
function DMComputeMenu_Callback(hObject, eventdata, handles)
% 调和分析批量处理，默认计算模式
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%读文件名
[Fname,Pname]=uigetfile({'*.txt','txt文件(*.txt)';'*.dat','dat文件(*.dat)';'*.*','所有符合要求的文件(*.*)'},'请挑选待处理的文件','MultiSelect','on');
%完整文件路径
if iscell(Fname)
    NFZ=length(Fname);
elseif Fname==0  %如果没有打开文件，则跳出程序
    QKtsxx(handles);     return;
else
    NFZ=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%显示参数的帮助信息
tinf=thcanshuhelp1( );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%%%输入基本的参数
%设置默认值
dep=struct('SCF','1','IBOL','2','IBIAO',...
    '4','IJG','1','IHS','8','QS','999999.0','CCH','30','BCH','5','WZ','30');
prompt={'单位换算因子','潮汐类型','潮汐表类型','可分潮波结构',...
    '时间系统','缺数标记','窗长(天,建议30或更长)','步长(天,范围：1至窗长)','结果位置(1至窗长)'};
title='参数赋值'; lines=1; resize='off';
hi=inputdlg(prompt,title,lines,struct2cell(dep),resize);
if isempty(hi)
    QKtsxx(handles);     return;
end
fields={'SCF','IBOL','IBIAO','IJG','IHS','QS','CCH','BCH','WZ'};
if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
PSCF=str2num(dep.SCF);
%%%清空提示信息栏
QKtsxx(handles);
load('Station.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j1NFZ=0;%用来统计选中但因命名不符合规定，未处理的文件个数
j2NFZ=0;%用来统计选中但因数据列数不符合要求，未处理的文件个数
j3NFZ=0;%用来统计选中但因数据不是整点值，未处理的文件个数
j4NFZ=0;%用来统计选中但因缺乏相应的台站信息，未处理的文件个数
jzNFZ=0;%用来统计选中但未处理的文件总个数

if NFZ==1%一个文件
    Fname={Fname};
end
for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];
    %如果不是默认命名的文件，则跳过文件
    FF=Fname{iiNFZ};
    cx=strmatch(FF(9:12),SFLDM);%判断测项是否包含在内置表内
    if length(FF)<12||isempty(cx)
        j1NFZ=j1NFZ+1;
        continue;
    end
    switch cx
        case 1
            dep.IZL='7';%体应变
        case {2,3,8,9,13,20,15,16,17,18,19,21}
            dep.IZL='2';%钻孔倾斜NS、EW,水管倾斜NS、EW、NE、NW,水平摆倾斜NS、EW,垂直摆倾斜NS、EW、NE、NW
        case {4,5,6,7,10,11,12,14}
            dep.IZL='4';%钻孔应变1-4分量,洞体应变NS、EW、NE、NW
        otherwise            
    end
    
    tkkx=strmatch(strcat(FF(1:5),FF(7)),[TZDM,CDBH]);
    kkx=strmatch(FF(9:12),FLDM(tkkx,:));
    kkx=tkkx(kkx);
    %kkx=intersect(strmatch(strcat(FF(1:5),FF(7)),[TZDM,CDBH]),);   
    %如果Station.mat文件里找不到相应信息，则跳过文件
    if isempty(kkx)
        j4NFZ=j4NFZ+1;
        continue;
    end   
    tmp=load(dbfile); [~,N]=size(tmp);
    %如果不是两列数据，则跳过文件
    if N~=2
        j2NFZ=j2NFZ+1;
        continue;
    else
        dataz=tmp(:,2);    timet=tmp(:,1);
        %如果不是整点值数据，则跳过文件
        if length(num2str(timet(1)))~=10
            j3NFZ=j3NFZ+1;
            continue;
        end
    end   
    %高程、方位角、经纬度赋值
    dep.HH=num2str(GC(kkx));
    dep.AZ=num2str(FWJ(kkx));
    dep.FB=num2str(JWD(kkx,2));
    dep.FL=num2str(JWD(kkx,1));
    %dep.SCF=num2str(PSCF*XS(kkx));
    dep.SCF=num2str(PSCF);
    %%%数据预处理，完成单位换算，从第一个非缺数的0点数据开始截取数据
    QS=str2num(dep.QS);
    [dataz,timet]=sjycl(dataz,timet,dep);    
    [dataz,timet]=tbds(dataz,timet,QS);%填补断数
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    timeuz=unique(fix(timet/100));%整日的时间序列
    handles.canshu=dep; handles.shuju=dataz;
    handles.shijian=timeuz; handles.pn=Pname;
    if length(FF)<=18
        nn=find(FF=='.')-1;
        handles.fn=[FF(1:nn),'_',deblank(TZM(kkx,:)),'_',deblank(FLM(kkx,:)),'.txt'];
    else
        handles.fn=FF;
    end
    handles.stif={['选中文件',num2str(NFZ),'个'];['开始第',num2str(iiNFZ),'个']};
    THFXLQ(handles,0);
end
jzNFZ=j1NFZ+j2NFZ+j3NFZ+j4NFZ;
set(handles.inform,'String',{['选中文件',num2str(NFZ),'个'];['其中',num2str(j1NFZ),'个因命名不符合规定未处理'];...
    [num2str(j2NFZ),'个因数据列数不符合要求未处理'];[num2str(j3NFZ),'个因数据不是整点值未处理'];[num2str(j4NFZ),...
    '个因缺乏相应的台站信息未处理'];['共计',num2str(jzNFZ),'个未处理']},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
return;