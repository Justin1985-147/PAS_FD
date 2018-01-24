%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%C                        FDXS.FOR                                     C
%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
function [S,C]=FDXS(W,IBOL,NB)
%求各分波的放大系数（扩大率）
H0=180/pi;
load SCN.mat
if IBOL==1
    CN=C1;
    SN=S1;
elseif IBOL==2
    CN=C2;
    SN=S2;
elseif IBOL==3
    CN=C3;
    SN=S3;
else
end

for I=1:NB
    C(I)=0;
    S(I)=0;
    for J=1:24
        W0=W(I)/H0;
        C(I)=C(I)+2*CN(J)*cos(W0*(J-0.5));
        S(I)=S(I)+2*SN(J)*sin(W0*(J-0.5));
    end
end