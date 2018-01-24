%-------------------------------------------------------------------------
%  [dataz,timet]=FillGap(dataz,timet,QS)
%  填补断数,最后更新时间2017-09-25
%-------------------------------------------------------------------------
function [dataz,timet]=FillGap(dataz,timet,QS)
ts1=num2str(timet(1));
ts2=num2str(timet(end));
len2=length(ts1);
len=length(timet);
if len2==14%秒值数据
    bcc=86400;
    strfor='yyyymmddHHMMSS';
elseif len2==12%分钟值数据
    bcc=1440;
    strfor='yyyymmddHHMM';
elseif len2==10%整点值数据
    bcc=24;
    strfor='yyyymmddHH';
elseif len2==8%日值数据
    bcc=1;
    strfor='yyyymmdd';
else
    return;
end
d2=datenum(ts2,strfor);
d1=datenum(ts1,strfor);
zjg=round((d2-d1)*bcc)+1;
if zjg==len%无断数
    return;
end
newtimet=d1:1/bcc:d2;
newtimet=newtimet(:);
newtimet=datevec(newtimet);
utimet=zeros(size(newtimet,1),1);
for ii=1:1:6
    if len2-2-ii*2>=0
        utimet=utimet+newtimet(:,ii)*10^(len2-2-ii*2);
    else
        break;
    end
end
newdata=QS*ones(length(utimet),1);
[timet,ib]=unique(timet);%数据有重复情况
dataz=dataz(ib);
[~,index,~]=intersect(utimet,timet);
newdata(index)=dataz;
dataz=newdata;
timet=utimet;
end