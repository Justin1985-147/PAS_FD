% --------------------------------------------------------------------
%  SelfCheckPlot(dep,alldbfile,allkkx,FWJ,TZM,FLDM)
%  �������߼��Լ��ϵ�����ڵ���3�������Ч��
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
FS=12;%�𼶱�ʾ�ֺ�
FN='Times New Roman';%�𼶱�ʾ����
LW=0.5;%�߿�
cc='krgb';
jl=[];
%%%%%%%%%
%����������
for ii=1:1:lenf
    dbfile=alldbfile{ii};
    tmp=load(dbfile); [~,N]=size(tmp);
    if N~=2%��������������ݣ����޷����ڼ���
        Vlenf=Vlenf-1;
        if Vlenf<3
            return;%�ļ�̫���޷�����
        else
            continue;
        end
    else
        datai=tmp(:,2);    timei=tmp(:,1);
        if length(num2str(timei(1)))~=10%�����������ֵ���ݣ����޷����ڼ���
            Vlenf=Vlenf-1;
            if Vlenf<3
                return;%�ļ�̫���޷�����
            else
                continue;
            end
        end
    end
    %%%����Ԥ������ɵ�λ���㣬�ӵ�һ����ȱ����0�����ݿ�ʼ��ȡ����
    QS=str2num(dep.QS);
    [datai,timei]=sjycl(datai,timei,dep);
    if isempty(timei)||length(timei)==1
        Vlenf=Vlenf-1;
        if Vlenf<3
            return;%�ļ�̫���޷�����
        else
            continue;
        end
    end
    fa=[fa,FWJ(allkkx(ii))];
    LenG=[LenG;{[FLDM(allkkx(ii),:),'-',num2str(FWJ(allkkx(ii)))]}];
    jl=[jl;ii];
    [datai,timei]=FillGap(datai,timei,QS);%�����
    if dep.YCL=='1'
        datai=EraDoubleS(datai,timei,QS,1);%�޲��ȫ������
    end
    if isempty(ttime)
        ttime=timei;
        dataz=datai;
    else
        [timet,IA,IB]=intersect(ttime,timei);%��ѡ����ʱ�������
        dataz=[dataz(IA,:),datai(IB,:)];
        ttime=timet;
    end
end
dataz(dataz==QS)=NaN;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yy=floor(ttime/1e6);%��
mm=mod(floor(ttime/1e4),1e2);%��
dd=mod(floor(ttime/1e2),1e2);%��
HH=mod(ttime,1e2);%Сʱ
xx=datenum([yy,mm,dd,HH,zeros(length(yy),2)]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
meandata=repmat(nanmean(dataz),length(xx),1);
hp=figure;
set(hp,'Position',[360 280 460 245]);
set(hp,'PaperPositionMode','auto');
hps=plot(xx,dataz-meandata,'LineWidth',LW);
for jj=1:1:length(jl)%�����������ָ��ÿ��������ɫ����ò��ֿ���ע��
    set(hps(jj),'color',cc(jl(jj)));
end
legend(LenG,'location','best');
datetick('x','yyyymmdd');
set(gca,'Position',[0.17 0.18 0.750 0.70]);
set(gca,'tickdir','out','FontName',FN,'FontSize',FS);
xlabel('����','FontName',FN,'FontSize',FS);
ylabel('Ӧ��۲�/������λ','FontName',FN,'FontSize',FS);
title(tname,'FontName',FN,'FontSize',FS);
Figname=strcat(Pname,FF(1:7),'_plot');
saveas(hp,Figname,'tif');
saveas(hp,Figname,'fig');
saveas(hp,Figname,'pdf');
close(hp);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Vlenf==4%���Ի��Լ�ͼ
    ind=fa>=180;
    fa(ind)=fa(ind)-180;
    ind=fa<0;
    fa(ind)=fa(ind)+180;
    if fa(1)+90==fa(2)||fa(1)-90==fa(2)%��������1��2��3��4����
        datazj=[dataz(:,1)+dataz(:,2),dataz(:,3)+dataz(:,4)];
        LenGG=['1+2';'3+4'];
    else%1��3��2��4����
        datazj=[dataz(:,1)+dataz(:,3),dataz(:,2)+dataz(:,4)];
        LenGG=['1+3';'2+4'];
    end
    meandata=repmat(nanmean(datazj),length(xx),1);
    hp=figure;
    set(hp,'Position',[360 280 460 245]);
    set(hp,'PaperPositionMode','auto');
    hps=plot(xx,datazj-meandata,'LineWidth',LW);
    for jj=1:1:2%�����������ָ��ÿ��������ɫ����ò��ֿ���ע��
        set(hps(jj),'color',cc(jj));
    end
    legend(LenGG,'location','best');
    datetick('x','yyyymmdd');
    set(gca,'Position',[0.17 0.18 0.750 0.70]);
    set(gca,'tickdir','out','FontName',FN,'FontSize',FS);
    xlabel('����','FontName',FN,'FontSize',FS);
    ylabel('Ӧ��۲�/������λ','FontName',FN,'FontSize',FS);
    title(tname,'FontName',FN,'FontSize',FS);
    Figname=strcat(Pname,FF(1:7),'_ZJplot');
    saveas(hp,Figname,'tif');
    saveas(hp,Figname,'fig');
    saveas(hp,Figname,'pdf');
    close(hp);
end
end