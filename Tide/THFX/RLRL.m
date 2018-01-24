%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%C                        RLR                                        C
%我的算法
%计算J1900.历元的儒略日，即自1900年1月0日12时UT1（JD=2415020.0）算起
%计算J2000.历元的儒略世纪数，即自2000年1月1日12时UT1（JD=2451545.0）算起
%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
function [DJ,T]=RLRL(NN,NY,NR,SH)
global IHS DT;
%IHS表示时间系统，8表示使用的SH等参数是北京时，0表示使用的是世界时UT1
%NN,NY,NR表示年月日
%SH表示时刻
%DT=56;
%郗老师原程序采用56S，源自《精密引潮位展开及某些诠释》
%56S为1988年外推地球力学时TDT与世界时UT1之差，计算时应采用质心力学时TDB，应TDB与TDT仅存微小周期性变化，故不区分。
%根据《天文算法》，2000年插值约67S
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
J=mid1+mid2+NR+A+1720994.5;%儒略日
DJ=J-2415020.0;
%自1900年1月1日12时UT1算起的儒略数，注意，J1900.0历元是自1900年1月0日12时UT1起算
T=(DJ+(SH-IHS+DT/3600)/24)/36525-1;
%J2000.历元的儒略世纪数，即自2000年1月1日12时UT1（JD=2451545.0）算起
end
