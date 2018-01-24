% --------------------------------------------------------------------
%  Compute_Tide_Rose(alldbfile,allkkx,GC,JWD,FWJ,TZM,dep)
%  计算并绘制潮汐因子玫瑰图的功能函数
% --------------------------------------------------------------------
function Compute_Tide_Rose(alldbfile,allkkx,GC,JWD,FWJ,TZM,dep)
tmpnn=alldbfile{1};
tname=TZM(allkkx(1),:);
Fnn=find(tmpnn=='\',1,'last');
Pname=tmpnn(1:Fnn);
FF=tmpnn(Fnn+1:end);
lenf=length(alldbfile);
Vlenf=lenf;
dataz=[];ttime=[];fa=[];
FactorZ=[];MsfZ=[];PhaseLZ=[];MspZ=[];
%高程、方位角、经纬度赋值
dep.HH=num2str(GC(allkkx(1)));
dep.FB=num2str(JWD(allkkx(1),2));
dep.FL=num2str(JWD(allkkx(1),1));
for ii=1:1:lenf
    dbfile=alldbfile{ii};
    tmp=load(dbfile); [~,N]=size(tmp);
    if N~=2%如果不是两列数据，则无法用于计算
        Vlenf=Vlenf-1;
        if Vlenf<3
            return;%文件太少无法计算
        else
            continue;
        end
    else
        datai=tmp(:,2);    timei=tmp(:,1);
        if length(num2str(timei(1)))~=10%如果不是整点值数据，则无法用于计算
            Vlenf=Vlenf-1;
            if Vlenf<3
                return;%文件太少无法计算
            else
                continue;
            end
        end
    end
    %%%数据预处理，完成单位换算，从第一个非缺数的0点数据开始截取数据
    QS=str2num(dep.QS);
    [datai,timei]=sjycl(datai,timei,dep);
    if isempty(timei)||length(timei)==1
        Vlenf=Vlenf-1;
        if Vlenf<3
            return;%文件太少无法计算
        else
            continue;
        end
    end
    fa=[fa,FWJ(allkkx(ii))];
    [datai,timei]=FillGap(datai,timei,QS);%填补断数
    if dep.YCL=='1'
        datai=EraDoubleS(datai,timei,QS,1);%无差别全部归零
    end
    if isempty(ttime)
        ttime=timei;
        dataz=datai;
    else
        [timet,IA,IB]=intersect(ttime,timei);%挑选公共时间段数据
        dataz=[dataz(IA,:),datai(IB,:)];
        ttime=timet;
    end
end
dataz(dataz==QS)=NaN;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fa0=str2num(dep.FWJ);
fa0=fa0(1):fa0(2):fa0(3);
[fa0j,~,ic]=unique(mod(fa0,180));%避免重复计算
ex=EveryStrainC(dataz,fa,fa0j);%计算出1系列应变
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
timeuz=unique(fix(ttime/100));%整日的时间序列
handles.shijian=timeuz; handles.pn=Pname;
hw=waitbar(0,'调和分析计算中...');
tic;%开始计时
for jj=1:1:length(fa0j)
    dep.AZ=num2str(fa0j(jj));
    handles.canshu=dep; handles.shuju=ex(:,jj);
    [Factor,Msf,PhaseL,Msp,timej,~]=RThfx(handles);
    FactorZ=[FactorZ,Factor(:,3)];
    MsfZ=[MsfZ,Msf(:,3)];
    PhaseLZ=[PhaseLZ,PhaseL(:,3)];
    MspZ=[MspZ,Msp(:,3)];
    waitbar(jj/length(fa0j),hw);
end
ex=ex(:,ic);
FactorZ=FactorZ(:,ic);
MsfZ=MsfZ(:,ic);
PhaseLZ=PhaseLZ(:,ic);
MspZ=MspZ(:,ic);
outname=strcat(Pname,FF(1:7),'_Rose','.mat');
save(outname,'FactorZ','MsfZ','PhaseLZ','MspZ','timej','ex','fa0','tname','Pname','FF','dep');
close(hw);
ttu=toc/60;
strtmp=['计算完毕======>','耗时',num2str(ttu),'分钟'];
disp(strtmp);
if dep.CT=='1'
    RoseGraph(FactorZ,timej,fa0,tname,Pname,FF,timej(1),timej(end),1);
end
end