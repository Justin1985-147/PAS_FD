% --------------------------------------------------------------------
%  PAS_FD_Tide_FRosegh_Callback(hObject, eventdata, handles)
%  计算并绘制潮汐因子玫瑰图
% --------------------------------------------------------------------
function PAS_FD_Tide_FRosegh_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Tide_FRosegh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dep=struct('QS','999999','FWJ','0,10,360','YCL','1','CT','1','SCF','0.1',...
    'IHS','8','CCH','30','BCH','90','WZ','30');
prompt={'缺数标记','玫瑰图起点，间隔，终点方位角','0不预处理，1去台阶及突跳','0不成图，1成图','单位换算因子',...
    '时间系统','窗长(天,建议30或更长)','步长(天,范围：1至窗长)','结果位置(1至窗长)'};
titleinput='基本参数'; lines=1; option.resize='on';option.windowstyle='normal';
hi=inputdlg(prompt,titleinput,lines,struct2cell(dep),option);
if isempty(hi)
    return;
end
fields={'QS','FWJ','YCL','CT','SCF','IHS','CCH','BCH','WZ'};
if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
dep.IBOL='2';
dep.IBIAO='4';
dep.IJG='1';
load('Station.mat');
%读文件名
[Fname,Pname]=uigetfile({'*.txt','txt文件(*.txt)';'*.dat','dat文件(*.dat)';'*.*','所有符合要求的文件(*.*)'},'请挑选用于计算的线应变文件','MultiSelect','on');
%完整文件路径
%%%%%%%%%%%%%%
%默认matlab文件名按序排列
%%%%%%%%%%%%%%
if iscell(Fname)
    NFZ=length(Fname);
elseif Fname==0  %如果没有打开文件，则跳出程序
    return;
else
    NFZ=1;
end
if NFZ<3
    return;%文件小于3个，无法求解
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GS=NFZ;
BJ=0;
alldbfile={};
allkkx=[];
dep.IZL='4';%钻孔应变1-4分量
for iiNFZ=1:1:NFZ
    FF=Fname{iiNFZ};
    dbfile=[Pname,FF];
    cx=strmatch(FF(9:12),SFLDM);
    if length(FF)<12||isempty(cx)||(cx~=4&&cx~=5&&cx~=6&&cx~=7)%非分量应变观测
        if BJ==3||BJ==4%新台站，且前面文件数量满足要求
            %%%%%%%%%%%%%%%%%
            Compute_Tide_Rose(alldbfile,allkkx,GC,JWD,FWJ,TZM,dep);
            BJ=0;
            alldbfile={};
            allkkx=[];
            %%%%%%%%%%%%%%%%%
        end
        GS=GS-1;
        if GS+BJ<3
            break;
        else
            continue;
        end
    end
    tkkx=strmatch(strcat(FF(1:5),FF(7)),[TZDM,CDBH]);
    kkx=strmatch(FF(9:12),FLDM(tkkx,:));
    kkx=tkkx(kkx);%测项在station表中的编号
    if isempty(kkx)
        if BJ==3||BJ==4%新台站，且前面文件数量满足要求
            %%%%%%%%%%%%%%%%%
            Compute_Tide_Rose(alldbfile,allkkx,GC,JWD,FWJ,TZM,dep);
            BJ=0;
            alldbfile={};
            allkkx=[];
            %%%%%%%%%%%%%%%%%
        end
        GS=GS-1;
        if GS+BJ<3
            break;
        else
            continue;
        end
    end
    %%%%%%%%%%%%%%%%%%%
    if BJ==0%还未读入台站首个测项
        tmptz=strcat(FF(1:5),FF(7));
        alldbfile={dbfile};
        BJ=1;
        allkkx=kkx;
    else%非首个测项
        if ~strcmp(tmptz,strcat(FF(1:5),FF(7)))%文件对应不同的台站
            if BJ==3||BJ==4%新台站，且前面文件数量满足要求
                %%%%%%%%%%%%%%%%%
                Compute_Tide_Rose(alldbfile,allkkx,GC,JWD,FWJ,TZM,dep);
                %%%%%%%%%%%%%%%%%
            end
            tmptz=strcat(FF(1:5),FF(7));
            alldbfile={dbfile};
            BJ=1;
            allkkx=kkx;
        else%同一台站
            alldbfile=[alldbfile;{dbfile}];
            BJ=BJ+1;
            allkkx=[allkkx;kkx];
            if iiNFZ==NFZ%最后一个文件
                if BJ==3||BJ==4%文件数量满足要求
                    %%%%%%%%%%%%%%%%%
                    Compute_Tide_Rose(alldbfile,allkkx,GC,JWD,FWJ,TZM,dep);
                    %%%%%%%%%%%%%%%%%
                end
            end
        end
    end
    GS=GS-1;
    if GS+BJ<3
        break;
    else
        continue;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end