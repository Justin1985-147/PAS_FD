%-------------------------------------------------------------------------
%����Ԥ������ɵ�λ���㣬�ӵ�һ����ȱ����0�����ݿ�ʼ��ȡ����
%-------------------------------------------------------------------------
function [dataz,timet]=sjycl(dataz,timet,dep)
QS=str2num(dep.QS); SCF=str2num(dep.SCF);
iin=find(dataz~=QS);%���ҳ����з�ȱ����λ��
dataz(iin)=dataz(iin)*SCF;%��λ���������ݣ�ȱ����Ǳ���
iin=find(dataz~=QS,1);%���ҳ���һ����ȱ����λ�ã��Ӵ˿�ʼ��ȡ����
dataz=dataz(iin:length(dataz));%��ȡ
timet=timet(iin:length(timet));%��ȡ
iin=find(mod(timet,100)==0,1);%���ҳ���һ��0��λ�ã��Ӵ˿�ʼ��ȡ����
dataz=dataz(iin:length(dataz));%��ȡ
timet=timet(iin:length(timet));%��ȡ
end