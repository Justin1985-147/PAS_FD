%-------------------------------------------------------------------------
%  [wzFtimeCO,wzFtimeAM]=CurveComp(datam,dataz,QS,StaCo,StaAm)
%  从时间序列中寻找与曲线模版类似的时段位置,返回形态类似时段以及形态类似且幅度类似时段位置,最后更新时间2014-8-27
%-------------------------------------------------------------------------
function [wzFtimeCO,wzFtimeAM]=CurveComp(datam,dataz,QS,StaCo,StaAm)
datam(datam==QS)=NaN;
dataz(dataz==QS)=NaN;
wwidth=length(datam);
FtimeCO=[];
RRco=[];
Ream=[];
for ii=1:1:length(dataz)-wwidth+1
    datau=dataz(ii:ii+wwidth-1);
    rr=corrcoef(datam,datau,'rows','pairwise');
    if rr(1,2)>StaCo
        FtimeCO=[FtimeCO;ii];
        RRco=[RRco;rr(1,2)];
        Ream=[Ream;abs((max(datau)-min(datau))/(max(datam)-min(datam))-1)];
    end
end

tmp=diff(FtimeCO);
tmp1=find(tmp>1);
tmp1=[1;tmp1+1;length(FtimeCO)+1];
wzFtimeCO=NaN*ones(length(tmp1)-1,1);
for ii=1:1:length(tmp1)-1
    [~,wzFtimeCO(ii)]=max(RRco(tmp1(ii):tmp1(ii+1)-1));
    wzFtimeCO(ii)=wzFtimeCO(ii)+tmp1(ii)-1;
end
wzFtimeAM=wzFtimeCO(Ream(wzFtimeCO)<StaAm);
wzFtimeCO=FtimeCO(wzFtimeCO);
wzFtimeAM=FtimeCO(wzFtimeAM);
end


