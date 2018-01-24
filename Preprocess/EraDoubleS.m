%-------------------------------------------------------------------------
%  dataz=EraDoubleS(dataz,timet,QS,lx)
%  去台阶及突跳点,最后更新时间2015-11-28
%-------------------------------------------------------------------------
function dataz=EraDoubleS(dataz,timet,QS,lx)
DS=1;%同时去台阶和突跳
[dataz,index2]=EraStep(dataz,timet,QS,lx,DS);
if length(index2)==length(dataz)%全部为缺数不处理
    return;
end
bs=3;%评价阈值为均方差的几倍
ddataz=diff(dataz);
tmpdd=sort(ddataz,'descend');
tmpdd=tmpdd(length(tmpdd)/20+1:end);
dmean=mean(tmpdd);%去掉影响较大的点求均值和均方差
dstd=std(tmpdd);
index1=find(abs(ddataz-dmean)>bs*dstd);%差分异常点，包含了台阶、突跳和连续突变点
if isempty(index1)%数据很好
    dataz(index2)=QS;
    return;
end
len2=length(index1);%差分异常点个数
if len2==1%一个点，台阶
    if index1==1
        ddataz(1)=0;
    elseif index1==length(ddataz)
        ddataz(end)=0;
    else
        ddataz(index1)=(ddataz(index1-1)+ddataz(index1+1))/2;
    end
else
    tmpxh=1:1:len2-1;
    index4=index1((index1(tmpxh)+1==index1(tmpxh+1))&(ddataz(index1(tmpxh)).*ddataz(index1(tmpxh+1))<0));%突跳点的特点：连续大差分值且符号相反
    index4=index4(:);
    index4=union(index4+1,index4);
    ddataz(index4)=0;
end
dataz=[dataz(1);dataz(1)+cumsum(ddataz)];
dataz(index2)=QS;
%%%%%%%%%%%%%%%%%
end