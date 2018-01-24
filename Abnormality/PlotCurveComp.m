%-------------------------------------------------------------------------
%  PlotCurveComp(datam,dataz,timet,QS,wzFtimeCO,wzFtimeAM,FF)
%  绘制时间序列与曲线模版类比图件,最后更新时间2014-8-27
%-------------------------------------------------------------------------
function PlotCurveComp(datam,dataz,timet,QS,wzFtimeCO,wzFtimeAM,FF)
datam(datam==QS)=NaN;
dataz(dataz==QS)=NaN;
stimet=num2str(timet);
[~,len2]=size(stimet);
if len2==14%秒值数据
    strfor='yyyymmddHHMMSS';
elseif len2==12%分钟值数据
    strfor='yyyymmddHHMM';
elseif len2==10%整点值数据
    strfor='yyyymmddHH';
elseif len2==8%日值数据
    strfor='yyyymmdd';
else
    return;
end
tnum=datenum(stimet,strfor);
LW1=2;
LW2=1;
wwidth=length(datam);
figure;
subplot(1,2,1)
hold on;
subplot(1,2,2)
hold on;
subplot(1,2,1)
plot(tnum,dataz,'k','Linewidth',LW1);
for ii=1:1:length(wzFtimeCO)
    tdata=dataz(wzFtimeCO(ii):wzFtimeCO(ii)+wwidth-1);
    tdata1=tdata;
    tdata1(isnan(tdata1))=[];
    xk=[wzFtimeCO(ii),wzFtimeCO(ii)+wwidth-1,wzFtimeCO(ii)+wwidth-1,wzFtimeCO(ii),wzFtimeCO(ii)];
    yk=[max(tdata1),max(tdata1),min(tdata1),min(tdata1),max(tdata1)];
    xk=tnum(xk);
    subplot(1,2,1)
    plot(xk,yk,'b','Linewidth',LW1);
    subplot(1,2,2)
    plot(tdata-mean(tdata1),'b','Linewidth',LW2);
end
for ii=1:1:length(wzFtimeAM)
    tdata=dataz(wzFtimeAM(ii):wzFtimeAM(ii)+wwidth-1);
    tdata1=tdata;
    tdata1(isnan(tdata1))=[];
    xk=[wzFtimeAM(ii),wzFtimeAM(ii)+wwidth-1,wzFtimeAM(ii)+wwidth-1,wzFtimeAM(ii),wzFtimeAM(ii)];
    yk=[max(tdata1),max(tdata1),min(tdata1),min(tdata1),max(tdata1)];
    xk=tnum(xk);
    subplot(1,2,1)
    plot(xk,yk,'r','Linewidth',LW1);
    subplot(1,2,2)
    plot(tdata-mean(tdata1),'r','Linewidth',LW2);
end
subplot(1,2,1)
ylabel('Amplitude');
title('The Time Postion Of Every Similar Curve');
axis(findobj(gcf,'Type','axes'),'tight');
tlabel(gca,'keepl','FixHigh',8);
xlabel('Time');
hold off;
tdata1=datam;
tdata1(isnan(tdata1))=[];
subplot(1,2,2)
plot(datam-mean(tdata1),'g','Linewidth',LW1);
ylabel('Amplitude');
xlabel('Time Serie No.');
title('The Similar Curves');
hold off;
set(gcf,'outerposition',get(0,'screensize'));
set(gcf,'Name',FF);
end