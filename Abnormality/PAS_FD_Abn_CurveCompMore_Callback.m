% --------------------------------------------------------------------
%  PAS_FD_Abn_CurveCompMore_Callback(hObject, eventdata, handles)
%  从所有测项中搜索与模版形态类似的时间段
% --------------------------------------------------------------------
function PAS_FD_Abn_CurveCompMore_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Abn_CurveCompMore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%
%读文件名
[Fname,Pname]=uigetfile({'*.txt','txt文件(*.txt)';'*.dat','dat文件(*.dat)';'*.*','所有符合要求的文件(*.*)'},'请挑选异常曲线模版所在的文件','MultiSelect','off');
%完整文件路径
if Fname==0  %如果没有打开文件，则跳出程序
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%
dbfile=[Pname,Fname];
tmp=load(dbfile); [~,N]=size(tmp);
%如果不是两列数据，则跳过文件
if N~=2
    msgbox('数据文件需要是通用的两列格式，请检查您的文件','未处理');
    return;
else
    dataz=tmp(:,2);    timet=tmp(:,1);
    clear tmp;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%
stimet=num2str(timet);
[~,len2]=size(stimet);
if len2==14%秒值数据
    strfor='yyyymmddHHMMSS';
elseif len2==12%分钟值数据
    strfor='yyyymmddHHMM';
elseif len2==10%整点值数据
    strfor='yyyymmddHH';
elseif len2==8%日值数据
    strfor='yyyymmdd';
else
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%
depCS=struct('QS','999999','Range','2014080100,2014082023','StaCo','0.8','StaAm','0.1');
prompt={'缺数标记','模版曲线段的时间范围（想从曲线上挑选则清空此参数）','相关系数阈值','相对幅度差阈值'};
titleinput='基本参数'; lines=1; option.resize='on';option.windowstyle='normal';
hi=inputdlg(prompt,titleinput,lines,struct2cell(depCS),option);
if length(hi)<1
    return;
end
QS=str2double(hi{1});
Range=str2num(hi{2});
StaCo=str2double(hi{3});
StaAm=str2double(hi{4});
if isempty(Range)
    tnum=datenum(stimet,strfor);
    tdataz=dataz;
    tdataz(tdataz==QS)=NaN;
    hh=figure;
    plot(tnum,tdataz);
    axis(findobj(gcf,'Type','axes'),'tight');
    tlabel(gcf,'keepl');
    title('通过zoom显示作为异常模版的时间段，确认后请按空格');
    set(gcf,'outerposition',get(0,'screensize'));
    xlabel('Time');
    ylabel('Amplitude');
    pause;
    Range=xlim;
    Range=str2num(datestr(Range,strfor));
    close(hh);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%
datam=dataz(find(timet==Range(1)):find(timet==Range(2)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%读文件名
[Fname,Pname]=uigetfile({'*.txt','txt文件(*.txt)';'*.dat','dat文件(*.dat)';'*.*','所有符合要求的文件(*.*)'},'请挑选所有待对比的文件','MultiSelect','on');
%完整文件路径
if iscell(Fname)
    NFZ=length(Fname);
elseif Fname==0  %如果没有打开文件，则跳出程序
    return;
else
    NFZ=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if NFZ==1%一个文件
    Fname={Fname};
end

j2NFZ=0;%用来统计选中但因数据列数不符合要求，未处理的文件个数
for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];
    FF=Fname{iiNFZ};
    tmp=load(dbfile); [~,N]=size(tmp);
    %如果不是两列数据，则跳过文件
    if N~=2
        j2NFZ=j2NFZ+1;
        continue;
    else
        dataz=tmp(:,2);    timet=tmp(:,1);
    end
    %%%%%%%%%%%%%%
    [wzFtimeCO,wzFtimeAM]=CurveComp(datam,dataz,QS,StaCo,StaAm);
    f_nn=find(FF=='.')-1;
    outname=strcat(Pname,FF(1:f_nn),'_CurveComp');
    PlotCurveComp(datam,dataz,timet,QS,wzFtimeCO,wzFtimeAM,outname);
    %输出
    saveas(gcf,outname,'emf');
    saveas(gcf,outname,'fig');
    close(gcf);
end