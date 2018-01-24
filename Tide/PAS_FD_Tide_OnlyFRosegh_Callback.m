% --------------------------------------------------------------------
%  PAS_FD_Tide_OnlyFRosegh_Callback(hObject, eventdata, handles)
%  绘制潮汐因子玫瑰图
% --------------------------------------------------------------------
function PAS_FD_Tide_OnlyFRosegh_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Tide_FRosegh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
depNew=struct('date1','','date2','','JG','1');
prompt={'玫瑰图绘制起始时间','玫瑰图绘制终止时间','绘制间隔（原计算间隔倍数）'};
titleinput='基本参数'; lines=1; option.resize='on';option.windowstyle='normal';
hi=inputdlg(prompt,titleinput,lines,struct2cell(depNew),option);
if isempty(hi)
    return;
end
fields={'date1','date2','JG'};
if size(hi,1)>0 depNew=cell2struct(hi,fields,1); end

%读文件名
[Fname,Pname]=uigetfile({'*Rose.mat','mat文件(*Rose.mat)'},'请挑选潮汐玫瑰图结果文件','MultiSelect','on');
%完整文件路径
if iscell(Fname)
    NFZ=length(Fname);
elseif Fname==0  %如果没有打开文件，则跳出程序
    return;
else
    NFZ=1;
    Fname={Fname};
end

for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];
    load(dbfile);
    if isempty(depNew.date1)
        tm1=timej(1);   
    else
        tm1=str2num(depNew.date1);
    end
    if isempty(depNew.date2)
        tm2=timej(end);
    else
        tm2=str2num(depNew.date2);
    end
    RoseGraph(FactorZ,timej,fa0,tname,Pname,FF,tm1,tm2,str2num(depNew.JG));
end
end