%--------------------------------------------------------------
%������עtick��label��title
%--------------------------------------------------------------
function [h2,h3,h4,h5,h6,cout]=BmTick(hth,xm,ym,jgt,TickJieguo,Fname,pre,f_mm,f_nn)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����
FNL=12;    FNX=10;%�ֺ�
FNNX='Times New Roman';
FNNL='����_GB2312';
mb=70;%����minorticklabel����������
ab=50;%���ڡ���ݡ��ľ���
zb=10;%������ticklabel����������
lj=9.1;%����xlabel����������
tl=40;%������tick
cout=[mb,zb,tl,lj,ab,FNX];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(hth,'FontSize',FNX,'FontName',FNNX);
xs1=xm(2)+(xm(2)-xm(1))/ab;
ys1=ym(1)-(ym(2)-ym(1))/mb;
ys2=ym(1)-(ym(2)-ym(1))/zb;
ys3=(ym(2)-ym(1))/tl+ym(1);
ys4=ym(1)-(ym(2)-ym(1))/lj;
if jgt<12
    xt=TickJieguo{1};%minortick��λ��
    xl=TickJieguo{2};%minortick��label
    xtm=TickJieguo{3};%��tick��λ��
    ml=TickJieguo{4};%��ticklabel
    set(hth,'xtick',xt);%minortick
    set(hth,'xticklabel',xl);%minorticklabel
    h2=text(xs1,ys1,'�·�','HorizontalAlignment','left','VerticalAlignment','top','FontSize',FNX,'FontName',FNNL);
    %��ticklabel
    if isempty(xtm)
        ns=TickJieguo{5};
        h3=text(sum(xm)/2,ys2,num2str(ns),'HorizontalAlignment',...
            'center','VerticalAlignment','top','FontSize',FNX,'FontName',FNNX);%����1������
    else
        h3=text(xtm,ys2*ones(1,length(xtm)),ml,'HorizontalAlignment',...
            'center','VerticalAlignment','top','FontSize',FNX,'FontName',FNNX);
    end
    h4=text(xs1,ys2,'���','HorizontalAlignment','left','VerticalAlignment','top','FontSize',FNX,'FontName',FNNL);
    %��tick
    lenx=length(xtm);  zxtm=[xtm';xtm';NaN*ones(1,lenx)];
    zxtm=zxtm(:);
    zytm=[ones(1,lenx)*ym(1);ones(1,lenx)*ys3;ones(1,lenx)*NaN];
    zytm=zytm(:);       h5=plot(hth,zxtm,zytm,'k');
    %
else
    xt=TickJieguo{1};%tick��λ��
    xl=TickJieguo{2};%tick��label
    set(hth,'xtick',xt);%tick
    set(hth,'xticklabel',xl);%ticklabel
    h2=text(xs1,ys1,'���','HorizontalAlignment','left','VerticalAlignment','top','FontSize',FNX,'FontName',FNNL);
    h3=[];            h4=[];            h5=[];
end
%h6=text(sum(xm)/2,ys4,'ʱ��','HorizontalAlignment','center','VerticalAlignment','top','FontSize',FNL,'FontName',FNNL);
h6=NaN;
pre=strrep(pre,'_','\_');
til=Fname(f_mm:f_nn);
til=strrep(til,'_','\_');
ylabel(pre,'FontSize',FNL,'FontName',FNNL);
title(til,'FontSize',FNL,'FontName',FNNL);
box off;
end