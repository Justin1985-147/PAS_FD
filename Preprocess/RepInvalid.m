%-------------------------------------------------------------------------
%  dataz=RepInvalid(dataz,QS,lx)
%  ȱ����ֵ,������ʱ��2014-8-30
%-------------------------------------------------------------------------
function [dataz,index2]=RepInvalid(dataz,QS,lx)
index2=find(dataz==QS);
if isempty(index2)%ȫ����ȱ��������
    return;
end
if length(index2)==length(dataz)%ȫ��Ϊȱ��������
    return;
end
datatmp=dataz;
xx=1:1:length(dataz);
xx(index2)=[];
datatmp(index2)=[];
if lx==1%
    method='nearest';
elseif lx==2
    method='linear';
elseif lx==3
    method='pchip';
elseif lx==4
    method='spline';
else
    return;
end
dataz(index2)=interp1(xx,datatmp,index2,method,'extrap');
end