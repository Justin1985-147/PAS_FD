%-------------------------------------------------------------------------
%  dataz=EraDoubleS(dataz,timet,QS,lx)
%  ȥ̨�׼�ͻ����,������ʱ��2015-11-28
%-------------------------------------------------------------------------
function dataz=EraDoubleS(dataz,timet,QS,lx)
DS=1;%ͬʱȥ̨�׺�ͻ��
[dataz,index2]=EraStep(dataz,timet,QS,lx,DS);
if length(index2)==length(dataz)%ȫ��Ϊȱ��������
    return;
end
bs=3;%������ֵΪ������ļ���
ddataz=diff(dataz);
tmpdd=sort(ddataz,'descend');
tmpdd=tmpdd(length(tmpdd)/20+1:end);
dmean=mean(tmpdd);%ȥ��Ӱ��ϴ�ĵ����ֵ�;�����
dstd=std(tmpdd);
index1=find(abs(ddataz-dmean)>bs*dstd);%����쳣�㣬������̨�ס�ͻ��������ͻ���
if isempty(index1)%���ݺܺ�
    dataz(index2)=QS;
    return;
end
len2=length(index1);%����쳣�����
if len2==1%һ���㣬̨��
    if index1==1
        ddataz(1)=0;
    elseif index1==length(ddataz)
        ddataz(end)=0;
    else
        ddataz(index1)=(ddataz(index1-1)+ddataz(index1+1))/2;
    end
else
    tmpxh=1:1:len2-1;
    index4=index1((index1(tmpxh)+1==index1(tmpxh+1))&(ddataz(index1(tmpxh)).*ddataz(index1(tmpxh+1))<0));%ͻ������ص㣺��������ֵ�ҷ����෴
    index4=index4(:);
    index4=union(index4+1,index4);
    ddataz(index4)=0;
end
dataz=[dataz(1);dataz(1)+cumsum(ddataz)];
dataz(index2)=QS;
%%%%%%%%%%%%%%%%%
end