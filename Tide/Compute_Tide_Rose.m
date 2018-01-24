% --------------------------------------------------------------------
%  Compute_Tide_Rose(alldbfile,allkkx,GC,JWD,FWJ,TZM,dep)
%  ���㲢���Ƴ�ϫ����õ��ͼ�Ĺ��ܺ���
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
%�̡߳���λ�ǡ���γ�ȸ�ֵ
dep.HH=num2str(GC(allkkx(1)));
dep.FB=num2str(JWD(allkkx(1),2));
dep.FL=num2str(JWD(allkkx(1),1));
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fa0=str2num(dep.FWJ);
fa0=fa0(1):fa0(2):fa0(3);
[fa0j,~,ic]=unique(mod(fa0,180));%�����ظ�����
ex=EveryStrainC(dataz,fa,fa0j);%�����1ϵ��Ӧ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
timeuz=unique(fix(ttime/100));%���յ�ʱ������
handles.shijian=timeuz; handles.pn=Pname;
hw=waitbar(0,'���ͷ���������...');
tic;%��ʼ��ʱ
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
strtmp=['�������======>','��ʱ',num2str(ttu),'����'];
disp(strtmp);
if dep.CT=='1'
    RoseGraph(FactorZ,timej,fa0,tname,Pname,FF,timej(1),timej(end),1);
end
end