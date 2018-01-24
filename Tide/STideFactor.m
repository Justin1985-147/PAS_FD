%-------------------------------------------------------------------------
%  STideFactor(fa0,FactorZ,MsfZ,timej,hfa,PPn,FFn,tname)
%  绘制某一角度的潮汐因子
%-------------------------------------------------------------------------
function STideFactor(fa0,FactorZ,MsfZ,timej,hfa,PPn,FFn,tname)
FS=12;%震级表示字号
FN='Times New Roman';%震级表示字体
LW=0.5;%线宽
MS=8;%markersize
color_error=0.7;%errorbar的灰度
cc='r';%颜色
mc='k';%makercolor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
index=find(fa0==hfa);
if ~isempty(index)
    titleT=[deblank(tname),'-[目标\实际]方位角为','[',num2str(hfa),'\',num2str(hfa),']度'];
else
    [~,index]=min(abs(fa0-hfa));
    titleT=[deblank(tname),'-[目标\实际]方位角为','[',num2str(hfa),'\',num2str(fa0(index)),']度'];
end
Factor=FactorZ(:,index);
Msf=MsfZ(:,index);
x=datenum(num2str(timej),'yyyymmdd');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hp=figure; hold on;
set(hp,'Position',[360 280 460 245]);
set(hp,'PaperPositionMode','auto');
errorbar(x,Factor,Msf,'color',color_error*ones(1,3),'LineStyle','none');
plot(x,Factor,cc,'LineWidth',LW,'Markersize',MS,'Marker','.','MarkerEdgecolor',mc);
hold off;
datetick('x','yyyymmdd');
set(gca,'Position',[0.1350 0.18 0.7750 0.70]);
set(gca,'tickdir','out','FontName',FN,'FontSize',FS);
xlabel('日期','FontName',FN,'FontSize',FS);
ylabel('M2波潮汐因子','FontName',FN,'FontSize',FS);
title(titleT,'FontName',FN,'FontSize',FS);
Figname=strcat(PPn,FFn(1:7),'_Tide',num2str(fa0(index)));
saveas(hp,Figname,'tif');
saveas(hp,Figname,'fig');
saveas(hp,Figname,'pdf');
close(hp);
end