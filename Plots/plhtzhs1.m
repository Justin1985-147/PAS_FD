%--------------------------------------------------------------------------
%批量画图里的子函数，用来实现成图功能
%--------------------------------------------------------------------------
function plhtzhs1(inli,inxxi,inxci,inxbi,data,xx,jgt,TickJieguo,Pname,Fname,txfznum,txzhenji,dep1,fwcs,tname)
%绘图参数
FNX=10;%震级表示字号
FNNX='Times New Roman';%震级表示字体
LW=0.8;%线宽
LWJ=1.2;%基准线宽
MS=6;%散点的大小
CZ={'k','r','g','b'};
%CZT={'黑色','红色','绿色','蓝色'};
cc=CZ{inxci};%颜色
XXZ={'-',':','.-','--','.'};
%XXZT={'实线','点线','点划线','划线','散点'};
xxi=XXZ{inxxi};
%JZ={'有基准线','无基准线'};
bs=fwcs(1);%控制曲线绘制范围
yxmi=fwcs(2);%控制曲线绘制范围
yxma=fwcs(3);%控制曲线绘制范围
pre=dep1.YL;
tjlx=dep1.TJLX;
f_nn=find(Fname=='.')-1;
f_mm=1;
if isempty(f_nn)
    f_nn=length(Fname);
end

hp=figure; hold on;
set(hp,'Position',[360 280 460 245]);
set(hp,'PaperPositionMode','auto');
%%%%%%%%%%%%%%%%%%%重复代码是为了减少判断次数
if inli==1
    plot(xx,data,[cc,xxi],'LineWidth',LW,'MarkerSize',MS);
    if inxbi==1
        plot(xx,zeros(length(xx),1),'r:','LineWidth',LWJ);
    end
    axis tight; ym=ylim; xm=xlim;
    
    if isnan(bs)==0%标准差限定
        yxi=find(isfinite(data));
        jzd=mean(data(yxi));
        sdd=std(data(yxi),1);
        ylim([jzd-bs*sdd jzd+bs*sdd]);
        ym=ylim;
    end
    if isnan(yxmi)==0%直接限定
        ylim([yxmi yxma]);
        ym=ylim;
    end
    
    BmTick(gca,xm,ym,jgt,TickJieguo,Fname,pre,f_mm,f_nn);
    if ~isempty(tname)
        title(tname);
    end
    hold off; %set(gcf,'outerposition',get(0,'screensize'));
    set(gca,'Position',[0.1300 0.140 0.7750 0.77])
    %Figname=strcat(Pname,Fname(f_mm:f_nn),CZT{inxci},XXZT{inxxi},JZ{inxbi});
    Figname=strcat(Pname,Fname(f_mm:f_nn));
    if sum(tjlx==1)~=0
        saveas(hp,Figname,'emf');
    end
    if sum(tjlx==2)~=0
        saveas(hp,Figname,'fig');
    end
    if sum(tjlx==3)~=0
        saveas(hp,Figname,'pdf');
    end
    close(hp);
else
    plot(xx,data,[cc,xxi],'LineWidth',LW,'MarkerSize',MS);
    if inxbi==1
        plot(xx,zeros(length(xx),1),'r:','LineWidth',LWJ);
    end
    axis tight; ym=ylim; xm=xlim;
    
    if isnan(bs)==0%标准差限定
        yxi=find(isfinite(data));
        jzd=mean(data(yxi));
        sdd=std(data(yxi),1);
        ylim([jzd-bs*sdd jzd+bs*sdd]);
        ym=ylim;
    end
    if isnan(yxmi)==0%直接限定
        ylim([yxmi yxma]);
        ym=ylim;
    end
    
    if ~isempty(txfznum)
        lentx=length(txfznum);
        yfw=ym(2)-ym(1); yyx=ym(2)-yfw/5; yys=ym(2)-yfw/10;
        dzx=[txfznum';txfznum';NaN*ones(1,lentx)];
        dzy=[yyx*ones(1,lentx);yys*ones(1,lentx);NaN*ones(1,lentx)];
        dzx=dzx(:); dzy=dzy(:); dzjb=plot(dzx,dzy,'r-');
        zjjb=text(txfznum,yys*ones(lentx,1),txzhenji,'VerticalAlignment','bottom','HorizontalAlignment','center','FontName', FNNX,'FontSize',FNX);
    end
    BmTick(gca,xm,ym,jgt,TickJieguo,Fname,pre,f_mm,f_nn);
    if ~isempty(tname)
        title(tname);
    end
    hold off; %set(gcf,'outerposition',get(0,'screensize'));
    set(gca,'Position',[0.1300 0.140 0.7750 0.77])
    %Figname=strcat(Pname,Fname(f_mm:f_nn),CZT{inxci},XXZT{inxxi},JZ{inxbi},'-标地震');
    Figname=strcat(Pname,Fname(f_mm:f_nn),'-标地震');
    if sum(tjlx==1)~=0
        saveas(hp,Figname,'emf');
    end
    if sum(tjlx==2)~=0
        saveas(hp,Figname,'fig');
    end
    if sum(tjlx==3)~=0
        saveas(hp,Figname,'pdf');
    end
    close(hp);
end
end