function ex=EveryStrainC(dataz,fa,fa0)
%����һϵ�з�λ����Ӧ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%dataz ÿ�ж�Ӧÿ���ļ������ݣ����滻ȱ��ΪNaN
%fa ���ļ���Ӧ��λ��
%fa0 ��Ҫ�����Ӧ�䷽λ������fa0=0:10:360
iinn=find(fa>=180);
fa(iinn)=fa(iinn)-180;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ns1,ew1,sor1,~,~,~,~,~]=StrainCbF(dataz',fa);
%��˳ʱ��Ϊ���ķ�λ��
fa0=fa0*pi/180;
lenf=length(fa0);
fa0=reshape(fa0,1,lenf);
ex=ns1*cos(fa0).^2+ew1*sin(fa0).^2-sor1*sin(2*fa0);%astra,���������λ��Ӧ��
end