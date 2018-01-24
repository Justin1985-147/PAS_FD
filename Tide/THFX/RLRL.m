%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%C                        RLR                                        C
%�ҵ��㷨
%����J1900.��Ԫ�������գ�����1900��1��0��12ʱUT1��JD=2415020.0������
%����J2000.��Ԫ������������������2000��1��1��12ʱUT1��JD=2451545.0������
%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
function [DJ,T]=RLRL(NN,NY,NR,SH)
global IHS DT;
%IHS��ʾʱ��ϵͳ��8��ʾʹ�õ�SH�Ȳ����Ǳ���ʱ��0��ʾʹ�õ�������ʱUT1
%NN,NY,NR��ʾ������
%SH��ʾʱ��
%DT=56;
%ۭ��ʦԭ�������56S��Դ�ԡ���������λչ����ĳЩڹ�͡�
%56SΪ1988�����Ƶ�����ѧʱTDT������ʱUT1֮�����ʱӦ����������ѧʱTDB��ӦTDB��TDT����΢С�����Ա仯���ʲ����֡�
%���ݡ������㷨����2000���ֵԼ67S
len=length(NR);
f=zeros(len,1);
g=zeros(len,1);
for ii=1:1:len
    if NY(ii)>=3
        f(ii)=NN(ii);
        g(ii)=NY(ii);
    elseif NY(ii)==1||NY(ii)==2
        f(ii)=NN(ii)-1;
        g(ii)=NY(ii)+12;
    else
    end
end

mid1=fix(365.25*f);
mid2=fix(30.6001*(g+1));
A=2-fix(f/100)+fix(f/400);
J=mid1+mid2+NR+A+1720994.5;%������
DJ=J-2415020.0;
%��1900��1��1��12ʱUT1�������������ע�⣬J1900.0��Ԫ����1900��1��0��12ʱUT1����
T=(DJ+(SH-IHS+DT/3600)/24)/36525-1;
%J2000.��Ԫ������������������2000��1��1��12ʱUT1��JD=2451545.0������
end
