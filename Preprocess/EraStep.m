%-------------------------------------------------------------------------
%  [dataz,index2]=EraStep(dataz,timet,QS,lx,DS)
%  去台阶,最后更新时间2015-11-28
%-------------------------------------------------------------------------
function [dataz,index2]=EraStep(dataz,timet,QS,lx,DS)
bs=3;%评价阈值为均方差的几倍
[dataz,index2]=RepInvalid(dataz,QS,1);
if length(index2)==length(dataz)%全部为缺数不处理
    return;
end
dataz=dataz(:);
timet=timet(:);
ddataz=diff(dataz);
tmpdd=sort(ddataz,'descend');
tmpdd=tmpdd(length(tmpdd)/20+1:end);
dmean=mean(tmpdd);%去掉影响较大的点求均值和均方差
dstd=std(tmpdd);
index1=find(abs(ddataz-dmean)>bs*dstd);%差分异常点，包含了台阶、突跳和大幅点
if isempty(index1)%数据很好
    if DS~=1%如果仅去台阶，则缺数还原
        dataz(index2)=QS;
    end
    return;
end
if length(index1)==1%一个点，台阶
    ddataz(index1)=0;
    dataz=[dataz(1);dataz(1)+cumsum(ddataz)];
    if DS~=1%如果仅去台阶，则缺数还原
        dataz(index2)=QS;
    end
    return;
end
dindex=diff(index1);%台阶点的话不连续，连续的为突跳点或持续突变点
index3=[];
if dindex(1)~=1
    index3=index1(1);
end
if length(dindex)>1
    if dindex(end)~=1
        index3=[index3;index1(end)];
    end
    dindex(1)=2;
    jg1=dindex(1:end-1)~=1;
    jg2=dindex(2:end)~=1;
    jg=find(jg1&jg2==1);
    if ~isempty(jg)
        jg=jg+1;
        index3=[index3;index1(jg)];
    end
end
len=length(num2str(timet(1)));%时间位数
if lx==1%无差别归零
    index4=union(index3,index2-1);
    index4(index4==0)=[];
else
    if lx==2%年归零
        ws=4;
        if len==14%秒值数据
            resi=101000000;
        elseif len==12%分钟值数据
            resi=1010000;
        elseif len==10%整点值数据
            resi=10100;
        elseif len==8%日值数据
            resi=101;
        else
            dataz(index2)=QS; return;
        end
    elseif lx==3%月归零
        ws=6;
        if len==14%秒值数据
            resi=1000000;
        elseif len==12%分钟值数据
            resi=10000;
        elseif len==10%整点值数据
            resi=100;
        elseif len==8%日值数据
            resi=1;
        else
            dataz(index2)=QS; return;
        end
    elseif lx==4%日归零
        ws=8;
        if len==14||len==12||len==10||len==8
            resi=0;
        else
            dataz(index2)=QS; return;
        end
    else
    end
    index4=union(index3(mod(timet(index3+1),10^(len-ws))==resi),index2-1);
    index4(index4==0)=[];
end
if isempty(index4)
    if DS~=1%如果仅去台阶，则缺数还原
        dataz(index2)=QS;
    end
    return;
end
ddataz(index4)=0;
dataz=[dataz(1);dataz(1)+cumsum(ddataz)];
if DS~=1%如果仅去台阶，则缺数还原
    dataz(index2)=QS;
end
end