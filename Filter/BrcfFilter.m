% --------------------------------------------------------------------
% 别尔采夫滤波
% --------------------------------------------------------------------
function [yf,yr]=BrcfFilter(dataz,QS)
% 别尔采夫滤波
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    dataz(find(dataz==QS))=NaN;%替换缺数为NaN，便于计算
    
    tmp=dataz;
    
    tmpf2=[ones(2,1)*NaN;dataz(1:end-2)];
    tmpf3=[ones(3,1)*NaN;dataz(1:end-3)];
    tmpf5=[ones(5,1)*NaN;dataz(1:end-5)];
    tmpf8=[ones(8,1)*NaN;dataz(1:end-8)];
    tmpf10=[ones(10,1)*NaN;dataz(1:end-10)];
    tmpf13=[ones(13,1)*NaN;dataz(1:end-13)];
    tmpf18=[ones(18,1)*NaN;dataz(1:end-18)];
    
    tmpz2=[dataz(1+2:end);ones(2,1)*NaN];
    tmpz3=[dataz(1+3:end);ones(3,1)*NaN];
    tmpz5=[dataz(1+5:end);ones(5,1)*NaN];
    tmpz8=[dataz(1+8:end);ones(8,1)*NaN];
    tmpz10=[dataz(1+10:end);ones(10,1)*NaN];
    tmpz13=[dataz(1+13:end);ones(13,1)*NaN];
    tmpz18=[dataz(1+18:end);ones(18,1)*NaN];

    yf=(tmp+tmpf2+tmpf3+tmpf5+tmpf8+tmpf10+tmpf13+tmpf18+tmpz2+tmpz3+tmpz5+tmpz8+tmpz10+tmpz13+tmpz18)/15;%瞬时零漂值
    yr=tmp-yf;%去除零漂后的结果
    yf(find(isnan(yf)))=QS;%替换NaN为缺数标记
    yr(find(isnan(yr)))=QS;%替换NaN为缺数标记
end