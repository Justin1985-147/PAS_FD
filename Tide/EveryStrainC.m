function ex=EveryStrainC(dataz,fa,fa0)
%计算一系列方位的线应变
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%dataz 每列对应每个文件的数据，已替换缺数为NaN
%fa 各文件对应方位角
%fa0 需要计算的应变方位，例如fa0=0:10:360
iinn=find(fa>=180);
fa(iinn)=fa(iinn)-180;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ns1,ew1,sor1,~,~,~,~,~]=StrainCbF(dataz',fa);
%以顺时针为正的方位角
fa0=fa0*pi/180;
lenf=length(fa0);
fa0=reshape(fa0,1,lenf);
ex=ns1*cos(fa0).^2+ew1*sin(fa0).^2-sor1*sin(2*fa0);%astra,计算给定方位的应变
end