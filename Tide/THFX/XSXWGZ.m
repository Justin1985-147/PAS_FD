%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%C                        XSXWGZ.FOR                                   C
%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
function [P,P1,G,G1]=XSXWGZ(IBOL,G,G1)
global AZ FB IZL
P=0;
P1=0;
H0=180/pi;
G0=G;
G10=G1;
if fix(IZL/2)==1
    [GA,GA1,GA2]=DDXS(3,IBOL);
    if IBOL==3
        CG=cos(AZ/H0);
        SG=GA1/G10*sin(AZ/H0);
        G1=G10*sqrt(SG^2+CG^2);
        P1=QP(SG,CG);
    else
        CG=cos(AZ/H0);
        SG=GA/G0*sin(AZ/H0);
        G=G0*sqrt(SG^2+CG^2);
        P=QP(SG,CG);
        CG=cos(AZ/H0);
        SG=GA1/G10*sin(AZ/H0);
        G1=G10*sqrt(SG^2+CG^2);
        P1=QP(SG,CG);
    end
elseif fix(IZL/2)==2
    [GA,GA1,GA2]=DDXS(5,IBOL);
    [GB,GB1,GA2]=DDXS(6,IBOL);
    if IBOL==3
        CG=(cos(AZ/H0))^2+GA1/G10*(sin(AZ/H0))^2;
        SG=-GB1/G10*sin(AZ/H0)*cos(AZ/H0);
        G1=G10*sqrt(SG^2+CG^2);
        P1=QP(SG,CG);
    else
        CG=(cos(AZ/H0))^2+GA/G0*(sin(AZ/H0))^2;
        SG=-GB/G0*sin(AZ/H0)*cos(AZ/H0);
        G=G0*sqrt(SG^2+CG^2);
        P=QP(SG,CG);
        CG=(cos(AZ/H0))^2+GA1/G10*(sin(AZ/H0))^2;
        SG=-GB1/G10*sin(AZ/H0)*cos(AZ/H0);
        G1=G10*sqrt(SG^2+CG^2);
        P1=QP(SG,CG);
    end
elseif fix(IZL/2)==3
    [GA,GA1,GA2]=DDXS(4,IBOL);
    [GB,GB1,GA2]=DDXS(5,IBOL);
    if IBOL==3
        CG=(GB1-GA1)*sin(2*AZ/H0);
        SG=G10*cos(2*AZ/H0);
        G1=sqrt(SG^2+CG^2);
        P1=QP(SG,CG);
        P1=-(P1+pi/2);
    else
        CG=(GB-GA)*sin(2*AZ/H0);
        SG=G0*cos(2*AZ/H0);
        G=sqrt(SG^2+CG^2);
        P=QP(SG,CG);
        P=-(P+pi/2);
        CG=(GB1-GA1)*sin(2*AZ/H0);
        SG=G10*cos(2*AZ/H0);
        G1=sqrt(SG^2+CG^2);
        P1=QP(SG,CG);
        P1=-(P1+pi/2);
    end
else
end
end