function [Factor,Msf,PhaseL,Msp,timej,FBM]=RThfx(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���������Ҫ��ȫ�ֱ���
global FB FL HH AZ IHS IZL IBIAO IJG DT QS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%������ֵ
%����Ĳ���ѡ��
IHS=str2num(handles.canshu.IHS);
IZL=str2num(handles.canshu.IZL);
IBOL=str2num(handles.canshu.IBOL);
IBIAO=str2num(handles.canshu.IBIAO);
IJG=str2num(handles.canshu.IJG);
%̨վ��Ϣ
FB=str2num(handles.canshu.FB);
FL=str2num(handles.canshu.FL);
HH=str2num(handles.canshu.HH);
AZ=str2num(handles.canshu.AZ);
%ʱ��
CCH=str2num(handles.canshu.CCH);
BCH=str2num(handles.canshu.BCH);
%����
SCF=str2num(handles.canshu.SCF);%��λ�������ӣ��ڵ��ñ�����ǰ�Ѿ�ʹ�ò�������
WZ=str2num(handles.canshu.WZ);%����Ľ����Ϊ�����ĸ�ʱ����ϵ���Ϣ
QS=str2num(handles.canshu.QS);%�����е�ȱ����ǣ�������ͬʱ������NaN��-+Inf,��Щ���ݶ������ڼ��㡣
%DT=56;%56SΪ1988�����Ƶ�����ѧʱTDT������ʱUT1֮�����5������ʱӦ����������ѧʱTDB����TDB��TDT����΢С�����Ա仯���ʲ����֡�
 DT=80;%80SΪ����2010��ʱ��ο���ΰ�����������㷨��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%׼������
dataz=handles.shuju;%�ܵ�����
timeuz=handles.shijian;%�ܵ�����ʱ������
len=length(timeuz);%���м��������
ds=fix((len-CCH)/BCH)+1;%�ܹ���Ҫ�ֵĶ���
db=24*BCH;%������Сʱ
dc=24*CCH;%������Сʱ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Factor=[];%��ϫ����
Msf=[];%����
PhaseL=[];%��λ�ͺ�
Msp=[];%����
timej=[];%��¼ʱ��

for ii=1:1:ds
    data=dataz(1+db*(ii-1):dc+db*(ii-1));
    timeu=timeuz(1+BCH*(ii-1):CCH+BCH*(ii-1));
    [FBM,jieguo]=THFX(timeu,data,IBOL);%FBM.name�ֲ���
    Factor=[Factor;jieguo(1,:)];%��ϫ���ӣ���ͬ�ж�Ӧ��ͬ�ֲ�
    Msf=[Msf;jieguo(2,:)];%���ȣ���ͬ�ж�Ӧ��ͬ�ֲ�
    PhaseL=[PhaseL;jieguo(3,:)];%��λ�ͺ󣬲�ͬ�ж�Ӧ��ͬ�ֲ�
    Msp=[Msp;jieguo(4,:)];%���ȣ���ͬ�ж�Ӧ��ͬ�ֲ�
    timej=[timej;timeu(WZ)];
end
PhaseL=XWLX(PhaseL);
clear global BM1 BN1 BM2 BN2 BM3 BN3 DL1 DL2 DL3 M T
end