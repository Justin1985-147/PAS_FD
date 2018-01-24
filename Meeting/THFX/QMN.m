%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%C                        QMN.FOR                                      C
%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
function QMN(timeu,data)
%��ѡ����48h�������飬����ΪM������ά��ϿƷ��˲�,"��BM��BN"
%�������޸���2013-11-12��Ҫ��ĸ�����Ƚ������������֤�������ݵ�Ԥ����
global T BM1 BN1 BM2 BN2 BM3 BN3 DL1 DL2 DL3 M QS
load SCN.mat;
T=[]; BM1=[]; BN1=[]; BM2=[]; BN2=[]; BM3=[]; BN3=[];
DL1=[]; DL2=[]; DL3=[];
NN=fix(timeu/10000);
NY=fix(timeu/100)-NN*100;
NR=timeu-NN*10000-NY*100;
[~,T0]=RLRL(NN,NY,NR,23.5);
ZS=length(NR);%���м�������
M=0;
II=1;

%��������������ѡ�������������ݣ�Ҫ����ѡ�����ݲ�����ȱ����NaN��-+Inf.
while II<ZS
    tdata=data(1+24*(II-1):24*II);
    if isempty(find(tdata==QS, 1))&&sum(isfinite(tdata))==24%���ݶ�������
        A=tdata;
    else%���ݶ��ڷ�����
        II=II+1;
        continue;
    end
    
    JJ=II+1;
    tdata=data(1+24*(JJ-1):24*JJ);
    if isempty(find(tdata==QS, 1))&&sum(isfinite(tdata))==24%���ݶ�������
        B=tdata;
        FA=flipud(A);
        Y=B+FA;
        Z=B-FA;
        M=M+1;
        BM1(M)=C1*Y;
        BN1(M)=S1*Z;
        BM2(M)=C2*Y;
        BN2(M)=S2*Z;
        BM3(M)=C3*Y;
        BN3(M)=S3*Z;
        T(M)=T0(II);
    end
    II=JJ+1;
end

if M~=0
    DL1=BM1*BM1'+BN1*BN1';
    DL2=BM2*BM2'+BN2*BN2';
    DL3=BM3*BM3'+BN3*BN3';
end

end