%-------------------------------------------------------------------------
%  [dataz,index2]=EraStep(dataz,timet,QS,lx,DS)
%  ȥ̨��,������ʱ��2015-11-28
%-------------------------------------------------------------------------
function [dataz,index2]=EraStep(dataz,timet,QS,lx,DS)
bs=3;%������ֵΪ������ļ���
[dataz,index2]=RepInvalid(dataz,QS,1);
if length(index2)==length(dataz)%ȫ��Ϊȱ��������
    return;
end
dataz=dataz(:);
timet=timet(:);
ddataz=diff(dataz);
tmpdd=sort(ddataz,'descend');
tmpdd=tmpdd(length(tmpdd)/20+1:end);
dmean=mean(tmpdd);%ȥ��Ӱ��ϴ�ĵ����ֵ�;�����
dstd=std(tmpdd);
index1=find(abs(ddataz-dmean)>bs*dstd);%����쳣�㣬������̨�ס�ͻ���ʹ����
if isempty(index1)%���ݺܺ�
    if DS~=1%�����ȥ̨�ף���ȱ����ԭ
        dataz(index2)=QS;
    end
    return;
end
if length(index1)==1%һ���㣬̨��
    ddataz(index1)=0;
    dataz=[dataz(1);dataz(1)+cumsum(ddataz)];
    if DS~=1%�����ȥ̨�ף���ȱ����ԭ
        dataz(index2)=QS;
    end
    return;
end
dindex=diff(index1);%̨�׵�Ļ���������������Ϊͻ��������ͻ���
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
len=length(num2str(timet(1)));%ʱ��λ��
if lx==1%�޲�����
    index4=union(index3,index2-1);
    index4(index4==0)=[];
else
    if lx==2%�����
        ws=4;
        if len==14%��ֵ����
            resi=101000000;
        elseif len==12%����ֵ����
            resi=1010000;
        elseif len==10%����ֵ����
            resi=10100;
        elseif len==8%��ֵ����
            resi=101;
        else
            dataz(index2)=QS; return;
        end
    elseif lx==3%�¹���
        ws=6;
        if len==14%��ֵ����
            resi=1000000;
        elseif len==12%����ֵ����
            resi=10000;
        elseif len==10%����ֵ����
            resi=100;
        elseif len==8%��ֵ����
            resi=1;
        else
            dataz(index2)=QS; return;
        end
    elseif lx==4%�չ���
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
    if DS~=1%�����ȥ̨�ף���ȱ����ԭ
        dataz(index2)=QS;
    end
    return;
end
ddataz(index4)=0;
dataz=[dataz(1);dataz(1)+cumsum(ddataz)];
if DS~=1%�����ȥ̨�ף���ȱ����ԭ
    dataz(index2)=QS;
end
end