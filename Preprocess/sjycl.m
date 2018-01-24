%-------------------------------------------------------------------------
%数据预处理，完成单位换算，从第一个非缺数的0点数据开始截取数据
%-------------------------------------------------------------------------
function [dataz,timet]=sjycl(dataz,timet,dep)
QS=str2num(dep.QS); SCF=str2num(dep.SCF);
iin=find(dataz~=QS);%查找出所有非缺数的位置
dataz(iin)=dataz(iin)*SCF;%单位换算后的数据，缺数标记保留
iin=find(dataz~=QS,1);%查找出第一个非缺数的位置，从此开始截取数据
dataz=dataz(iin:length(dataz));%截取
timet=timet(iin:length(timet));%截取
iin=find(mod(timet,100)==0,1);%查找出第一个0点位置，从此开始截取数据
dataz=dataz(iin:length(dataz));%截取
timet=timet(iin:length(timet));%截取
end