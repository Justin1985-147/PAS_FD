%-------------------------------------------------------------------------
%  ZjnjdBar(A)
%  绘制自检内精度
%-------------------------------------------------------------------------
function ZjnjdBar(A)
FN='Times New Roman';
FS=15;
A(A(:,2)==999999,:)=[];
x=datenum(num2str(A(:,1)),'yyyymmdd');
bar(x,A(:,6));
datetick('x','yyyymmdd');
set(gca,'tickdir','out','FontName',FN,'FontSize',FS);
ylim([0 1]);
xlabel('日期','FontName',FN,'FontSize',FS);
ylabel('自检内精度','FontName',FN,'FontSize',FS);
end