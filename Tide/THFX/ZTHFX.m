%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%C                        ZTHFX.FOR                                    C
%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
function [BBM,DELTA,SIGMAD,FKAPA,SIGMAK,SIGMA0]=ZTHFX(BM,BN,IBOL,DL)

global IZL IBIAO IJG M T AZ

load BQQSH.mat;
load CXB.mat;
load BOM.mat;

H0=180/pi;
L=(IBIAO-1)*12+(IJG-1)*3+IBOL;
NP=BQQSH(L).NP;

if M<=NP
    DELTA=NaN*ones(1,NP);
    FKAPA=NaN*ones(NP,1);
    SIGMAD=NaN*ones(1,NP);
    SIGMAK=NaN*ones(1,NP);
    SIGMA0=NaN;
    K=(IJG-1)*3+IBOL;
    BBM(1:NP)=BOM(1:NP,K);
else
    IBETA=BQQSH(L).IBETA;
    IALFA(1)=1;
    if NP~=1
        IALFA(2:NP)=IBETA(1:NP-1)+1;
    end
    NB=IBETA(NP);
    CXB0=CXB(IBOL+1);
    if IBIAO==1
        IG=CXB0.IG1;
    elseif IBIAO==2
        IG=CXB0.IG2;
    elseif IBIAO==3
        IG=CXB0.IG3;
    elseif IBIAO==4
        IG=CXB0.IG4;
    else
    end
    index1=1:1:NB;
    index2=find(IG~=0);
    index3=index2(index1);
    IA=CXB0.IA(index3);
    IB=CXB0.IB(index3);
    IC=CXB0.IC(index3);
    ID=CXB0.ID(index3);
    IE=CXB0.IE(index3);
    IF=CXB0.IF(index3);
    ISC=CXB0.ISC(index3);
    WI=CXB0.WI(index3);%郗老师程序里的W
    FH=CXB0.FH(index3);
    
    [G,G1,G2]=DDXS(IZL,IBOL);
    F=0;
    F1=F;
    if mod(IZL,2)||AZ==0||IZL==8
        [SN,CN]=FDXS(WI,IBOL,NB);
    else
        [F,F1,G,G1]=XSXWGZ(IBOL,G,G1);
        [SN,CN]=FDXS(WI,IBOL,NB);
    end
    FW=zeros(2*NP,1);
    FN=zeros(2*NP,2*NP);
    FKAPA=zeros(NP,1);
    
    for I=1:M
        [TAO,S,H,P,N,PS]=TWYS(T(I),23.5);
        for J=1:NP
            A(2*J-1)=0;
            A(2*J)=0;
            B(2*J-1)=0;
            B(2*J)=0;
            for K=IALFA(J):IBETA(J)
                IM=fix(ISC(K)/10);
                if IM==4&&IZL~=1
                    continue;
                else
                    FAI=XW(IZL,IA(K),IB(K),IC(K),ID(K),IE(K),IF(K),ISC(K),TAO,S,H,P,N,PS);
                    FAI=FAI/H0;
                    
                    if IM==2
                        G0=G;
                    elseif IM==3
                        G0=G1;
                    elseif IM==4
                        G0=G2;
                    else
                    end
                    if mod(IZL,2)==0
                        if IM==2
                            F0=F;
                        elseif IM==3
                            F0=F1;
                        else
                        end
                        FAI=FAI+F0;
                        
                    else
                    end
                    
                    A(2*J-1)=A(2*J-1)+CN(K)*FH(K)*G0*cos(FAI);
                    A(2*J)=A(2*J)+CN(K)*FH(K)*G0*sin(FAI);
                    B(2*J-1)=B(2*J-1)-SN(K)*FH(K)*G0*sin(FAI);
                    B(2*J)=B(2*J)+SN(K)*FH(K)*G0*cos(FAI);
                    
                end
            end
        end
        
        for K=1:2*NP
            FW(K)=FW(K)+A(K)*BM(I)+B(K)*BN(I);
            for J=1:2*NP
                FN(K,J)=FN(K,J)+A(K)*A(J)+B(K)*B(J);
            end
        end
    end
    
    FQ=FN;
    FQ=QN(FQ,2*NP);
    X=JZXC(FQ,FW,2*NP);
    X=GSJ(FN,FQ,X,FW,2*NP);
    
    for I=1:2*NP
        DL=DL-X(I)*FW(I);
    end
    SIGMA0=sqrt(DL/(2*(M-NP)));
    
    for I=1:NP
        X2=X(2*I-1)*X(2*I-1);
        Y2=X(2*I)*X(2*I);
        CA=FQ(2*I-1,2*I-1);
        CB=FQ(2*I,2*I);
        XY=2*X(2*I-1)*X(2*I)*FQ(2*I-1,2*I);
        DELTA(I)=sqrt(X2+Y2);
        FKAPA(I)=atan2(-X(2*I),X(2*I-1))*H0;
        SIGMAD(I)=SIGMA0*sqrt(X2*CA+Y2*CB+XY)/DELTA(I);
        SIGMAK(I)=SIGMA0*sqrt(Y2*CA+X2*CB-XY)/DELTA(I)^2*H0;
        K=(IJG-1)*3+IBOL;
        BBM(I)=BOM(I,K);
    end
end
end
