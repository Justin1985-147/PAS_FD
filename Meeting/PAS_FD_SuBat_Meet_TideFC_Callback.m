% --------------------------------------------------------------------
%  PAS_FD_SuBat_Meet_TideFC_Callback(hObject, eventdata, handles)
%  会商中用于潮汐因子的跟踪（追加新结果）
% --------------------------------------------------------------------
function PAS_FD_SuBat_Meet_TideFC_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_SuBat_Meet_TideF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%说明：认为数据经过了预处理,仅考虑追加
%读数据文件名
Pname=uigetdir(pwd,'选择数据文件所在目录');
if Pname==0
    return;
end
FnameT=struct2cell(dir(Pname));
ID=cell2mat(FnameT(4,:));
Fname=FnameT(1,~ID);
if isempty(Fname)
    return;%无数据文件则跳出
end
%读结果文件名
OPname=uigetdir(pwd,'选择结果文件所在目录');
if OPname==0
    return;
end
FnameT=struct2cell(dir(OPname));
ID=cell2mat(FnameT(4,:));
OFname=FnameT(1,~ID);%可能为空
Fname=cell2mat(Fname');
OFname=cell2mat(OFname');
%%%%%%%%%%%%%%%
hw=waitbar(0,'潮汐因子跟踪计算中...','Name',['共',num2str(size(OFname,1)),'个文件']);
tic;%开始计时
upnoF=0;%更新的结果文件数
for ii=1:1:size(OFname,1)%以结果文件为准，只计算之前存在的文件
    [~,jj,~] = intersect(Fname(:,1:12),OFname(ii,4:15),'rows');
    if ~isempty(jj)%有数据文件
        dbfile1=[Pname,'\',Fname(jj,:)];
        dbfile2=[OPname,'\',OFname(ii,:)];
        tmp=load(dbfile1);
        load(dbfile2);
        %台站测项信息
        dep.HH=HH;
        dep.AZ=AZ;
        dep.FB=FB;
        dep.FL=FL;
        %处理参数信息
        dep.IHS=IHS;
        dep.IZL=IZL;
        dep.IBOL=IBOL;
        dep.IBIAO=IBIAO;
        dep.IJG=IJG;
        %窗长参数
        dep.CCH=CCH;
        dep.BCH=BCH;
        dep.WZ=WZ;
        %其它信息
        dep.SCF=SCF;
        dep.QS=QS;
        %新数据的最后一个日期至少要大于LastDate才需要计算
        LastDate=str2num(datestr(datenum(num2str(timej(end)),'yyyymmdd')+BCH+CCH-WZ,'yyyymmdd'));
        dataz=tmp(:,2);    timet=tmp(:,1);
        if timet(end)>=LastDate*100+23;%有必要计算
            FirstDate=str2num(datestr(datenum(num2str(timej(end)),'yyyymmdd')+BCH+1-WZ,'yyyymmdd'));%从FirstDate开始截取数据进行计算
            ind=find(timet==FirstDate*100);
            dataz=dataz(ind:end);
            timet=timet(ind:end);
            %单位换算
            dataz(dataz~=QS)=dataz(dataz~=QS)*SCF;
            %
            result.Factor=Factor;
            result.Msf=Msf;
            result.PhaseL=PhaseL;
            result.Msp=Msp;
            result.timej=timej;
            result.FBM=FBM;
            %
            timeuz=unique(fix(timet/100));%整日的时间序列
            handles.canshu=dep; handles.shuju=dataz;
            handles.shijian=timeuz;
            handles.result=result;
            handles.outname=dbfile2;
            THFXLQm(handles);
            upnoF=upnoF+1;%更新的结果文件数
        end
    end
    waitbar(ii/size(OFname,1),hw);
end
close(hw);
ttu=toc/60;
strtmp=['共',num2str(size(OFname,1)),'个结果文件，','保存在',OPname,'，共耗时',num2str(ttu),'分钟；其中',num2str(upnoF),'个结果文件进行了更新'];
msgbox(strtmp,'处理完毕');