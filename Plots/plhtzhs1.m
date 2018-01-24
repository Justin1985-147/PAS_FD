%--------------------------------------------------------------------------
%������ͼ����Ӻ���������ʵ�ֳ�ͼ����
%--------------------------------------------------------------------------
function plhtzhs1(inli,inxxi,inxci,inxbi,data,xx,jgt,TickJieguo,Pname,Fname,txfznum,txzhenji,dep1,fwcs,tname)
%��ͼ����
FNX=10;%�𼶱�ʾ�ֺ�
FNNX='Times New Roman';%�𼶱�ʾ����
LW=0.8;%�߿�
LWJ=1.2;%��׼�߿�
MS=6;%ɢ��Ĵ�С
CZ={'k','r','g','b'};
%CZT={'��ɫ','��ɫ','��ɫ','��ɫ'};
cc=CZ{inxci};%��ɫ
XXZ={'-',':','.-','--','.'};
%XXZT={'ʵ��','����','�㻮��','����','ɢ��'};
xxi=XXZ{inxxi};
%JZ={'�л�׼��','�޻�׼��'};
bs=fwcs(1);%�������߻��Ʒ�Χ
yxmi=fwcs(2);%�������߻��Ʒ�Χ
yxma=fwcs(3);%�������߻��Ʒ�Χ
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
%%%%%%%%%%%%%%%%%%%�ظ�������Ϊ�˼����жϴ���
if inli==1
    plot(xx,data,[cc,xxi],'LineWidth',LW,'MarkerSize',MS);
    if inxbi==1
        plot(xx,zeros(length(xx),1),'r:','LineWidth',LWJ);
    end
    axis tight; ym=ylim; xm=xlim;
    
    if isnan(bs)==0%��׼���޶�
        yxi=find(isfinite(data));
        jzd=mean(data(yxi));
        sdd=std(data(yxi),1);
        ylim([jzd-bs*sdd jzd+bs*sdd]);
        ym=ylim;
    end
    if isnan(yxmi)==0%ֱ���޶�
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
    
    if isnan(bs)==0%��׼���޶�
        yxi=find(isfinite(data));
        jzd=mean(data(yxi));
        sdd=std(data(yxi),1);
        ylim([jzd-bs*sdd jzd+bs*sdd]);
        ym=ylim;
    end
    if isnan(yxmi)==0%ֱ���޶�
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
    %Figname=strcat(Pname,Fname(f_mm:f_nn),CZT{inxci},XXZT{inxxi},JZ{inxbi},'-�����');
    Figname=strcat(Pname,Fname(f_mm:f_nn),'-�����');
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