%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%C                        QMN.FOR                                      C
%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
function QMN(timeu,data)
%挑选连续48h的数据组，个数为M，进行维尼迪科夫滤波,"求BM、BN"
%本代码修改于2013-11-12，要求母函数先进行填补断数、保证逐日数据等预处理。
global T BM1 BN1 BM2 BN2 BM3 BN3 DL1 DL2 DL3 M QS
load SCN.mat;
T=[]; BM1=[]; BN1=[]; BM2=[]; BN2=[]; BM3=[]; BN3=[];
DL1=[]; DL2=[]; DL3=[];
NN=fix(timeu/10000);
NY=fix(timeu/100)-NN*100;
NR=timeu-NN*10000-NY*100;
[~,T0]=RLRL(NN,NY,NR,23.5);
ZS=length(NR);%共有几天数据
M=0;
II=1;

%从数据中依次挑选连续的两天数据，要求挑选的数据不包含缺数及NaN，-+Inf.
while II<ZS
    tdata=data(1+24*(II-1):24*II);
    if isempty(find(tdata==QS, 1))&&sum(isfinite(tdata))==24%数据段内连续
        A=tdata;
    else%数据段内非连续
        II=II+1;
        continue;
    end
    
    JJ=II+1;
    tdata=data(1+24*(JJ-1):24*JJ);
    if isempty(find(tdata==QS, 1))&&sum(isfinite(tdata))==24%数据段内连续
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