% --------------------------------------------------------------------
%  PAS_FD_Tide_SpeAzi_Callback(hObject, eventdata, handles)
%  由潮汐玫瑰结果绘制指定方位潮汐因子
% --------------------------------------------------------------------
function PAS_FD_Tide_SpeAzi_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Tide_FRosegh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dep=struct('FWJ','0,10,360');
prompt={'欲绘制潮汐因子的起点，间隔，终点方位角'};
titleinput='基本参数'; lines=1; option.resize='on';option.windowstyle='normal';
hi=inputdlg(prompt,titleinput,lines,struct2cell(dep),option);
if isempty(hi)
    return;
end
fields={'FWJ'};
if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
%读文件名
[FFname,PPname]=uigetfile({'*Rose.mat','mat文件(*Rose.mat)'},'请挑选潮汐玫瑰图结果文件','MultiSelect','on');
%完整文件路径
if iscell(FFname)
    NFZ=length(FFname);
elseif FFname==0  %如果没有打开文件，则跳出程序
    return;
else
    NFZ=1;
    FFname={FFname};
end

hfa=str2num(dep.FWJ);
for iiNFZ=1:1:NFZ
    dbfile=[PPname,FFname{iiNFZ}];
    load(dbfile);
    for hfa0=hfa(1):hfa(2):hfa(3)
        STideFactor(fa0,FactorZ,MsfZ,timej,hfa0,PPname,FFname{iiNFZ},tname); 
    end  
end
end