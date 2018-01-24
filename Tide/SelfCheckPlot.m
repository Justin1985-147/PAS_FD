% --------------------------------------------------------------------
%  SelfCheckPlot(dep,alldbfile,allkkx,FWJ,TZM,FLDM)
%  绘制曲线及自检关系（大于等于3测项才有效）
% --------------------------------------------------------------------
function SelfCheckPlot(dep,alldbfile,allkkx,FWJ,TZM,FLDM)
tmpnn=alldbfile{1};
tname=deblank(TZM(allkkx(1),:));
Fnn=find(tmpnn=='\',1,'last');
Pname=tmpnn(1:Fnn);
FF=tmpnn(Fnn+1:end);
lenf=length(alldbfile);
Vlenf=lenf;
dataz=[];ttime=[];fa=[];
LenG={};
%%%%%%%%%
FS=12;%震级表示字号
FN='Times New Roman';%震级表示字体
LW=0.5;%线宽
cc='krgb';
jl=[];
%%%%%%%%%
%画单个曲线
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
    LenG=[LenG;{[FLDM(allkkx(ii),:),'-',num2str(FWJ(allkkx(ii)))]}];
    jl=[jl;ii];
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yy=floor(ttime/1e6);%年
mm=mod(floor(ttime/1e4),1e2);%月
dd=mod(floor(ttime/1e2),1e2);%日
HH=mod(ttime,1e2);%小时
xx=datenum([yy,mm,dd,HH,zeros(length(yy),2)]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
meandata=repmat(nanmean(dataz),length(xx),1);
hp=figure;
set(hp,'Position',[360 280 460 245]);
set(hp,'PaperPositionMode','auto');
hps=plot(xx,dataz-meandata,'LineWidth',LW);
for jj=1:1:length(jl)%如果不需特意指定每条曲线颜色，则该部分可以注释
    set(hps(jj),'color',cc(jl(jj)));
end
legend(LenG,'location','best');
datetick('x','yyyymmdd');
set(gca,'Position',[0.17 0.18 0.750 0.70]);
set(gca,'tickdir','out','FontName',FN,'FontSize',FS);
xlabel('日期','FontName',FN,'FontSize',FS);
ylabel('应变观测/基本单位','FontName',FN,'FontSize',FS);
title(tname,'FontName',FN,'FontSize',FS);
Figname=strcat(Pname,FF(1:7),'_plot');
saveas(hp,Figname,'tif');
saveas(hp,Figname,'fig');
saveas(hp,Figname,'pdf');
close(hp);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Vlenf==4%可以画自检图
    ind=fa>=180;
    fa(ind)=fa(ind)-180;
    ind=fa<0;
    fa(ind)=fa(ind)+180;
    if fa(1)+90==fa(2)||fa(1)-90==fa(2)%部分仪器1和2，3和4正交
        datazj=[dataz(:,1)+dataz(:,2),dataz(:,3)+dataz(:,4)];
        LenGG=['1+2';'3+4'];
    else%1和3，2和4正交
        datazj=[dataz(:,1)+dataz(:,3),dataz(:,2)+dataz(:,4)];
        LenGG=['1+3';'2+4'];
    end
    meandata=repmat(nanmean(datazj),length(xx),1);
    hp=figure;
    set(hp,'Position',[360 280 460 245]);
    set(hp,'PaperPositionMode','auto');
    hps=plot(xx,datazj-meandata,'LineWidth',LW);
    for jj=1:1:2%如果不需特意指定每条曲线颜色，则该部分可以注释
        set(hps(jj),'color',cc(jj));
    end
    legend(LenGG,'location','best');
    datetick('x','yyyymmdd');
    set(gca,'Position',[0.17 0.18 0.750 0.70]);
    set(gca,'tickdir','out','FontName',FN,'FontSize',FS);
    xlabel('日期','FontName',FN,'FontSize',FS);
    ylabel('应变观测/基本单位','FontName',FN,'FontSize',FS);
    title(tname,'FontName',FN,'FontSize',FS);
    Figname=strcat(Pname,FF(1:7),'_ZJplot');
    saveas(hp,Figname,'tif');
    saveas(hp,Figname,'fig');
    saveas(hp,Figname,'pdf');
    close(hp);
end
end