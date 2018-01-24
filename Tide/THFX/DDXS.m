%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%C                        DDXS.FOR                                     C
%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
function [G,G1,G2]=DDXS(IZL,IBOL)
%根据数据类型和波群类别返回相应的"大地系数"
%公式基本来源于《固体潮汐与引潮参数》
global HH FB
G=0;G1=0;G2=0;
H0=180/pi;
FB0=FB/H0;%观测点地理纬度
RA=1-0.00332479*sin(FB0)^2+HH/6378140;%p/a
G0G=1/(1+0.0053024*sin(FB0)^2-0.0000059*sin(2*FB0)^2);%g0/g
EPSILON=0.192424*sin(2*FB0)/H0;%地理纬度与地心纬度之差
FB0=FB0-EPSILON;%地心纬度
S=sin(FB0);
C=cos(FB0);
S2=S*S;
C2=C*C;
SS2=2*S*C;
CC2=C2-S2;
SEP=sin(EPSILON);%郗老师原程序中认为EPSILON足够小，因而余弦为1，正弦为0
CEP=cos(EPSILON);
IBOL0=IBOL+1;
if IZL==1%重力
    CV=41.2908*RA;%41.2908来源于D/a
    CV1=CV*RA;
    CV2=CV1*RA;
    if IBOL0==1%长周期波，包含2、3阶球函数
        G=-CV*((1-3*S2)*CEP-1.5*SS2*SEP);%垂直分量大地系数Z20
        G1=-3.35409*CV1*(S*(3-5*S2)*CEP-C*(5*S2-1)*SEP);%垂直分量大地系数Z30
        G2=-0.50000*CV2*(3-30*S2+35*S2*S2);%垂直分量大地系数Z40？没有找到来源
    elseif IBOL0==2%日波，包含2、3阶球函数
        G=-2*CV*(SS2*CEP+CC2*SEP);%垂直分量大地系数Z21
        G1=-0.72618*CV1*(3*C*(1-5*S2)*CEP-S*(15*C2-4)*SEP);%垂直分量大地系数Z31
        G2=-1.89384*CV2*SS2*(3-7*S2);%垂直分量大地系数Z41？没有找到来源
    elseif IBOL0==3%半日波，包含2、3阶球函数
        G=-CV*(2*C2*CEP-SS2*SEP);%垂直分量大地系数Z22
        G1=-2.59808*CV1*(3*S*C2*CEP+C*(3*C2-2)*SEP);%垂直分量大地系数Z32
        G2=-3.11112*CV2*C2*(1-7*S2);%垂直分量大地系数Z42？没有找到来源
    elseif IBOL0==4%1/3日波，包含3阶球函数
        G1=-3*CV1*(C2*C*CEP-S*C2*SEP);%垂直分量大地系数Z33
        G2=-12.31680*CV2*S*C2*C;%垂直分量大地系数Z43？
    elseif IBOL0==5%1/4日波？
        G2=-4.00000*CV2*C2*C2;%垂直分量大地系数Z44？
    else
    end
elseif IZL==2||IZL==3%倾斜
    CH=8.708*RA*G0G;%垂线偏差公式中的系数
    CH1=CH*RA;
    if IZL==2%南北分量，南北向垂线偏差的潮汐波和引潮力位、重力的相同，不同的仅是大地系数
        if IBOL0==1%长周期波，包含2、3阶球函数
            G=-CH*(1.5*SS2*CEP+(1-3*S2)*SEP);%垂线偏差之大地系数e20
            G1=-3.35409*CH1*(C*(5*S2-1)*CEP+S*(3-5*S2)*SEP);%垂线偏差之大地系数e30
        elseif IBOL0==2%日波，包含2、3阶球函数
            G=2*CH*(CC2*CEP-SS2*SEP);%垂线偏差之大地系数e21
            G1=-0.72618*CH1*(S*(15*C2-4)*CEP+3*C*(1-5*S2)*SEP);%垂线偏差之大地系数e31
        elseif IBOL0==3%半日波，包含2、3阶球函数
            G=-CH*(SS2*CEP+2*C2*SEP);%垂线偏差之大地系数e22
            G1=2.59808*CH1*(C*(3*C2-2)*CEP-3*S*C2*SEP);%垂线偏差之大地系数e32
        elseif IBOL0==4%1/3日波，包含3阶球函数
            G1=-3*CH1*(S*C2*CEP+C2*C*SEP);%垂线偏差之大地系数e33
        else
        end
    elseif IZL==3%东西分量，没有长周期波
        if IBOL0==1
            G=0;
            G1=0;
        elseif IBOL0==2%日波，包含2、3阶球函数
            G=2*CH*S;%垂线偏差之大地系数n21
            G1=0.72618*CH1*(1-5*S2);%垂线偏差之大地系数n31
        elseif IBOL0==3%半日波，包含2、3阶球函数
            G=2*CH*C;%垂线偏差之大地系数n22
            G1=2.59808*CH1*SS2;%垂线偏差之大地系数n32
        elseif IBOL0==4%1/3日波，包含3阶球函数
            G1=3*CH1*C2;%垂线偏差之大地系数n33
        else
        end
    else
    end
elseif IZL==4||IZL==5||IZL==6%应变
    CE=42.2182*RA*G0G;%换算成10的-9为单位
    CE1=CE*RA;
    L2=0.0832;%Farrell按照古登堡-布伦A模型推导出来的勒夫数
    H2=0.6114;
    L3=0.0145;
    H3=0.2913;
    if IZL==4%南北应变
        if IBOL0==1%长周期波，包含2、3阶球函数
            G=CE*(-3*L2*CC2+0.5*H2*(1-3*S2));%南北应变潮汐之大地系数20
            G1=1.11803*CE1*S*(3*L3*(4-15*C2)+H3*(3-5*S2));%南北应变潮汐之大地系数30
        elseif IBOL0==2%日波，包含2、3阶球函数
            G=CE*SS2*(-4*L2+H2);%南北应变潮汐之大地系数21
            G1=0.72618*CE1*C*(L3*(45*S2-11)+H3*(1-5*S2));%南北应变潮汐之大地系数31
        elseif IBOL0==3%半日波，包含2、3阶球函数
            G=CE*(-2*L2*CC2+H2*C2);%南北应变潮汐之大地系数22
            G1=2.59808*CE1*S*(L3*(2-9*C2)+H3*C2);%南北应变潮汐之大地系数32
        elseif IBOL0==4%1/3日波，包含3阶球函数
            G1=CE1*C*(3*L3*(3*S2-1)+H3*C2);%南北应变潮汐之大地系数33
        else
        end
    elseif IZL==5%东西应变
        if IBOL0==1%长周期波，包含2、3阶球函数
            G=CE*(3*L2*S2+0.5*H2*(1-3*S2));%东西应变潮汐之大地系数20
            G1=1.11803*CE1*S*(-3*L3*(1-5*S2)+H3*(3-5*S2));%东西应变潮汐之大地系数30
        elseif IBOL0==2%日波，包含2、3阶球函数
            G=CE*SS2*(-2*L2+H2);%东西应变潮汐之大地系数21
            G1=0.72618*CE1*C*(L3*(15*S2-1)+H3*(1-5*S2));%东西应变潮汐之大地系数31
        elseif IBOL0==3%半日波，包含2、3阶球函数
            G=CE*(-2*L2*(1+C2)+H2*C2);%东西应变潮汐之大地系数22
            G1=2.59808*CE1*S*(L3*(3*S2-5)+H3*C2);%东西应变潮汐之大地系数32
        elseif IBOL0==4%1/3日波，包含3阶球函数
            G1=CE1*C*(-3*L3*(C2+2)+H3*C2);%东西应变潮汐之大地系数33
        else
        end
    elseif IZL==6%应变剪切分量
        if IBOL0==1%没有长周期波
            G=0;
            G1=0;
        elseif IBOL0==2%日波，包含2、3阶球函数
            G=-4*CE*L2*C;%剪切应变潮汐之大地系数21
            G1=0.72618*CE1*(10*L3*SS2);%剪切应变潮汐之大地系数31
        elseif IBOL0==3%半日波，包含2、3阶球函数
            G=4*CE*L2*S;%剪切应变潮汐之大地系数22
            G1=-2.59808*CE1*(4*L3*CC2);%剪切应变潮汐之大地系数32
        elseif IBOL0==4%1/3日波，包含3阶球函数
            G1=6*CE1*L3*SS2;%剪切应变潮汐之大地系数33
        else
        end
    else
    end
elseif IZL==7||IZL==8%体应变和面应变，大地系数参考《地表的面应变和体应变固体潮汐理论值计算及其调和分析》
    CB=20.366*RA*G0G;%没有找到来源
    CB1=11.500*RA;
    if IBOL0==1%长周期波，包含2、3阶球函数
        G=0.5*CB*(1-3*S2);%体应变潮汐之大地系数N20
        G1=1.11803*CB1*S*(3-5*S2);%体应变潮汐之大地系数N30
    elseif IBOL0==2%日波，包含2、3阶球函数
        G=CB*SS2;%体应变潮汐之大地系数N21
        G1=0.72618*CB1*C*(1-5*S2);%体应变潮汐之大地系数N31
    elseif IBOL0==3%半日波，包含2、3阶球函数
        G=CB*C2;%体应变潮汐之大地系数N22
        G1=2.59808*CB1*S*C2;%体应变潮汐之大地系数N32
    elseif IBOL0==4%1/3日波，包含3阶球函数
        G1=CB1*C2*C;%体应变潮汐之大地系数N33
    else
    end
    if IZL==8%面应变,泊松比取0.25，自由表面的情况
        G=G*3/2;
        G1=G1*3/2;
    end
else
end
end