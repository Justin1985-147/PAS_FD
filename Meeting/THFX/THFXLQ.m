function THFXLQ(handles,wb)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%定义计算需要的全局变量
global FB FL HH AZ IHS IZL IBIAO IJG DT QS
%显示提示信息
if wb==1
    tif={['开始计算' handles.pn handles.fn];'可能会需要一段时间'};
else
    tif={['开始计算' handles.pn handles.fn];'可能会需要一段时间';handles.stif{1};handles.stif{2}};
end
set(handles.inform,'String',tif,'Fontsize',10,'Fontweight','bold','Horizontalalignment','left');
pause(1);
tic;%开始计时
if wb==1
    hw=waitbar(0,'调和分析计算中...','Name',[handles.pn handles.fn]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%参数赋值
%处理的参数选择
IHS=str2num(handles.canshu.IHS);
IZL=str2num(handles.canshu.IZL);
IBOL=str2num(handles.canshu.IBOL);
IBIAO=str2num(handles.canshu.IBIAO);
IJG=str2num(handles.canshu.IJG);
%台站信息
FB=str2num(handles.canshu.FB);
FL=str2num(handles.canshu.FL);
HH=str2num(handles.canshu.HH);
AZ=str2num(handles.canshu.AZ);
%时窗
CCH=str2num(handles.canshu.CCH);
BCH=str2num(handles.canshu.BCH);
%其他
SCF=str2num(handles.canshu.SCF);%单位换算因子，在调用本函数前已经使用并换算了
WZ=str2num(handles.canshu.WZ);%计算的结果认为代表哪个时间点上的信息
QS=str2num(handles.canshu.QS);%数据中的缺数标记，程序中同时考虑了NaN，-+Inf,这些数据都不用于计算。
%DT=56;%56S为1988年外推地球力学时TDT与世界时UT1之差，计算5个幅角时应采用质心力学时TDB，因TDB与TDT仅存微小周期性变化，故不区分。
DT=80;%80S为外推2010年时差，参考许剑伟译著《天文算法》
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%准备数据
dataz=handles.shuju;%总的数据
timeuz=handles.shijian;%总的整日时间序列
len=length(timeuz);%共有几天的数据
ds=fix((len-CCH)/BCH)+1;%总共需要分的段数
db=24*BCH;%步长，小时
dc=24*CCH;%窗长，小时
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Factor=[];%潮汐因子
Msf=[];%精度
PhaseL=[];%相位滞后
Msp=[];%精度
timej=[];%记录时间

for ii=1:1:ds
    data=dataz(1+db*(ii-1):dc+db*(ii-1));
    timeu=timeuz(1+BCH*(ii-1):CCH+BCH*(ii-1));
    [FBM,jieguo]=THFX(timeu,data,IBOL);%FBM.name分波名
    Factor=[Factor;jieguo(1,:)];%潮汐因子，不同列对应不同分波
    Msf=[Msf;jieguo(2,:)];%精度，不同列对应不同分波
    PhaseL=[PhaseL;jieguo(3,:)];%相位滞后，不同列对应不同分波
    Msp=[Msp;jieguo(4,:)];%精度，不同列对应不同分波
    timej=[timej;timeu(WZ)];
    if wb==1
    waitbar(ii/ds,hw);
    end
end
PhaseL=XWLX(PhaseL);
clear global BM1 BN1 BM2 BN2 BM3 BN3 DL1 DL2 DL3 M T
f_nn=find(handles.fn=='.')-1;
if isempty(f_nn)
    f_nn=length(handles.fn);
end
outname=strcat(handles.pn,'TH-',handles.fn(1:f_nn),'.mat');
save(outname,'Factor','Msf','PhaseL','Msp','timej','FBM','IHS','IZL','IBOL',...
     'IBIAO','IJG','FB','FL','HH','AZ','CCH','BCH','WZ','QS','SCF'); 
ttu=toc/60;
if wb==1
tinf={['计算完毕======>','耗时',num2str(ttu),'分钟'];...
      ['调和分析的所有结果保存在',outname,'中'];...
      '                                                   ';...
      '可以使用matlab打开查看,其中包含：';'Factor:每一列对应一种分波潮汐因子序列';...
      'Msf:每一列对应一种分波潮汐因子的误差序列';'PhaseL:每一列对应一种分波潮汐因子的相位滞后序列';...
      'Msp:每一列对应一种分波潮汐因子的相位滞后误差序列';'timej:对应记录的时间';...
      'FBM:它的每一分量的name依次对应之前各列的分波名称';...
      '                                                   ';...
      '台站信息：FB(纬度),FL(经度),HH(高程),AZ(方位角)';...
      '参数信息：IHS(时间系统),IZL(数据类型),IBOL(潮汐类型),IBIAO(潮汐表类型),IJG(可分潮波结构)';...
      '其他信息：CCH(窗长),BCH(步长),WZ(结果位置),QS(缺数标记),SCF(单位换算因子)'};
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
close(hw);
end
end