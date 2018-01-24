%--------------------------------------------------------------
%用来标注tick，label及title
%--------------------------------------------------------------
function [h2,h3,h4,h5,h6,cout]=BmTick(hth,xm,ym,jgt,TickJieguo,Fname,pre,f_mm,f_nn)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%参数
FNL=12;    FNX=10;%字号
FNNX='Times New Roman';
FNNL='楷体_GB2312';
mb=70;%调节minorticklabel离坐标轴间距
ab=50;%调节“年份”的距离
zb=10;%调节主ticklabel离坐标轴间距
lj=9.1;%调节xlabel离坐标轴间距
tl=40;%调节主tick
cout=[mb,zb,tl,lj,ab,FNX];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(hth,'FontSize',FNX,'FontName',FNNX);
xs1=xm(2)+(xm(2)-xm(1))/ab;
ys1=ym(1)-(ym(2)-ym(1))/mb;
ys2=ym(1)-(ym(2)-ym(1))/zb;
ys3=(ym(2)-ym(1))/tl+ym(1);
ys4=ym(1)-(ym(2)-ym(1))/lj;
if jgt<12
    xt=TickJieguo{1};%minortick的位置
    xl=TickJieguo{2};%minortick的label
    xtm=TickJieguo{3};%主tick的位置
    ml=TickJieguo{4};%主ticklabel
    set(hth,'xtick',xt);%minortick
    set(hth,'xticklabel',xl);%minorticklabel
    h2=text(xs1,ys1,'月份','HorizontalAlignment','left','VerticalAlignment','top','FontSize',FNX,'FontName',FNNL);
    %主ticklabel
    if isempty(xtm)
        ns=TickJieguo{5};
        h3=text(sum(xm)/2,ys2,num2str(ns),'HorizontalAlignment',...
            'center','VerticalAlignment','top','FontSize',FNX,'FontName',FNNX);%不足1年的情况
    else
        h3=text(xtm,ys2*ones(1,length(xtm)),ml,'HorizontalAlignment',...
            'center','VerticalAlignment','top','FontSize',FNX,'FontName',FNNX);
    end
    h4=text(xs1,ys2,'年份','HorizontalAlignment','left','VerticalAlignment','top','FontSize',FNX,'FontName',FNNL);
    %主tick
    lenx=length(xtm);  zxtm=[xtm';xtm';NaN*ones(1,lenx)];
    zxtm=zxtm(:);
    zytm=[ones(1,lenx)*ym(1);ones(1,lenx)*ys3;ones(1,lenx)*NaN];
    zytm=zytm(:);       h5=plot(hth,zxtm,zytm,'k');
    %
else
    xt=TickJieguo{1};%tick的位置
    xl=TickJieguo{2};%tick的label
    set(hth,'xtick',xt);%tick
    set(hth,'xticklabel',xl);%ticklabel
    h2=text(xs1,ys1,'年份','HorizontalAlignment','left','VerticalAlignment','top','FontSize',FNX,'FontName',FNNL);
    h3=[];            h4=[];            h5=[];
end
%h6=text(sum(xm)/2,ys4,'时间','HorizontalAlignment','center','VerticalAlignment','top','FontSize',FNL,'FontName',FNNL);
h6=NaN;
pre=strrep(pre,'_','\_');
til=Fname(f_mm:f_nn);
til=strrep(til,'_','\_');
ylabel(pre,'FontSize',FNL,'FontName',FNNL);
title(til,'FontSize',FNL,'FontName',FNNL);
box off;
end