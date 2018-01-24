% --------------------------------------------------------------------
%  PAS_FD_Filt_Digital_Callback(hObject, eventdata, handles)
%  批量绘制time-data形式的二维曲线
% --------------------------------------------------------------------
function PAS_FD_Plots_Single_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Plots_Single (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%
%读文件名
[Fname,Pname]=uigetfile({'*.*','时间序列数据(*.*)'},'请挑选待绘图的文件','MultiSelect','on');
%完整文件路径
if iscell(Fname)
    NFZ=length(Fname);
elseif Fname==0  %如果没有打开文件，则跳出程序
    return;
else
    NFZ=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
canshu=handles.canshu.canshu11;
if canshu{1}==1
    dnFW=[1];
    [inFW,valueFW]=listdlg('PromptString','是否对绘图范围进行限定','SelectionMode',...
        'Single','ListString',{'否','几倍标准差限定','直接给出范围'},...
        'InitialValue',dnFW,'ListSize',[200 250]);
    if valueFW==0
        return;
    end
    if inFW==2
        depfw=struct('bs','6');
        prompt={'超过几倍标准差的数据点不绘出'};
        title='绘图范围限定'; lines=1; resize='on';
        hi=inputdlg(prompt,title,lines,struct2cell(depfw),resize);
        if isempty(hi)
            return;
        end
        fields={'bs'};
        if size(hi,1)>0 depfw=cell2struct(hi,fields,1); end
        fwcs=[str2num(depfw.bs),NaN,NaN];
    elseif inFW==3
        depfw=struct('yxmi','0','yxma','1');
        prompt={'y坐标最小值','y坐标最大值'};
        title='绘图范围限定'; lines=1; resize='on';
        hi=inputdlg(prompt,title,lines,struct2cell(depfw),resize);
        if isempty(hi)
            return;
        end
        fields={'yxmi','yxma'};
        if size(hi,1)>0 depfw=cell2struct(hi,fields,1); end
        fwcs=[NaN,str2num(depfw.yxmi),str2num(depfw.yxma)];
    else
        fwcs=[NaN,NaN,NaN];
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    dep1=struct('QS','999999','YL','应变(10^{-10})');
    prompt={'数据中的缺数标记','y轴label'};
    title='参数设置'; lines=1; resize='off';
    hi1=inputdlg(prompt,title,lines,struct2cell(dep1),resize);
    if isempty(hi1)
        return;
    end
    fields={'QS','YL'};
    if size(hi1,1)>0 dep1=cell2struct(hi1,fields,1); end
    dnxx=[1];
    [inxx,valuexx]=listdlg('PromptString','选择曲线类型','SelectionMode',...
        'Single','ListString',{'实线-','点线:','点划线.-','划线--','散点'},...
        'InitialValue',dnxx,'ListSize',[200 250]);
    if valuexx==0
        return;
    end
    dnxc=[1];
    [inxc,valuexc]=listdlg('PromptString','选择曲线颜色','SelectionMode',...
        'Single','ListString',{'黑色','红色','绿色','蓝色'},...
        'InitialValue',dnxc,'ListSize',[200 250]);
    if valuexc==0
        return;
    end
    dnxb=[2];
    [inxb,valuexb]=listdlg('PromptString','是否添加y=0的基准线','SelectionMode',...
        'Single','ListString',{'是','否'},...
        'InitialValue',dnxb,'ListSize',[200 250]);
    if valuexb==0
        return;
    end
    QS=str2num(dep1.QS);
else
    fwcs=str2num(cell2mat(canshu(2:4)'));
    yl=canshu{6};
    if length(yl)==1&&yl=='空'
        yl='';
    end
    inxx=str2num(canshu{7});
    inxc=str2num(canshu{8});
    inxb=str2num(canshu{9});
    tmp=canshu{10};
    tjlx=[];
    for it=1:1:length(tmp)
        tjlx=[tjlx,str2num(tmp(it))];
    end
    QS=str2num(canshu{5});
    dep1=struct('QS',num2str(QS),'YL',yl,'TJLX',tjlx);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if NFZ==1%一个文件与多个文件读取有些差别
    Fname={Fname};
end
load('Station.mat');
for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];        drsj=load(dbfile); %导入数据
    [~,N]=size(drsj);
    %如果不是两列数据，则跳过文件
    if N~=2
        continue;
    end
    %%%%%%%%%%%%%%%%%%%%%%%
    FF=Fname{iiNFZ};
    if length(FF)<12
        tname='';%图名
    else
        cx=strmatch(FF(9:12),SFLDM);%判断测项是否包含在内置表内
        if isempty(cx)
            tname='';%图名
        else
            houzhui=SFLM(cx,:);
            tkkx=strmatch(strcat(FF(1:5),FF(7)),[TZDM,CDBH]);
            if ~isempty(tkkx)
                tname=[deblank(TZM(tkkx(1),:)),houzhui];
            else
                tname='';
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%
    timej=drsj(:,1);
    data=drsj(:,2);
    %[data,timej]=FillGap(data,timej,QS);%填补断数
    data(data==QS)=NaN;%替换缺数为NaN，便于画图
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %刻度及label位置
    stdate=timej(1);%第一个时间
    etdate=timej(end);%最后一个时间
    ttp=length(num2str(timej(1)));%时间位数
    if ttp==8
        yy=floor(timej/1e4);%年
        mm=mod(floor(timej/1e2),1e2);%月
        dd=mod(timej,1e2);%日
        xx=datenum([yy,mm,dd]);
        tend=timej(end);
    elseif ttp==10
        yy=floor(timej/1e6);%年
        mm=mod(floor(timej/1e4),1e2);%月
        dd=mod(floor(timej/1e2),1e2);%日
        HH=mod(timej,1e2);%小时
        xx=datenum([yy,mm,dd,HH,zeros(length(yy),2)]);
        tend=fix(timej(end)/100);
    elseif ttp==12
        yy=floor(timej/1e8);%年
        mm=mod(floor(timej/1e6),1e2);%月
        dd=mod(floor(timej/1e4),1e2);%日
        HH=mod(floor(timej/1e2),1e2);%小时
        MM=mod(timej,1e2);%分钟
        xx=datenum([yy,mm,dd,HH,MM,zeros(length(yy),1)]);
        tend=fix(timej(end)/10000);
    end
    styy=mm(1);%第一个月份
    stnn=yy(1);%第一个年份
    ys=floor((xx(end)-xx(1))/30)+1;%大致月数
    
    jgt=round(ys/12);%取几个月作为minortick间隔,1年数据以月为间隔，2年数据以2月为间隔
    if jgt==5
        jgt=4;
    elseif jgt==0
        jgt=1;
    elseif jgt>5
        jgt=12*ceil(ys/120);%6年以上数据直接用一种tick
    end
    
    TickJieguo=FHXtick(jgt,stnn,styy,tend);%返回tick及label
    FF=Fname{iiNFZ};
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    txfznum=[];
    txzhenji=[];
    for jj=1:1:length(inxx)
        for mm=1:1:length(inxc)
            for nn=1:1:length(inxb)
                plhtzhs1(1,inxx(jj),inxc(mm),inxb(nn),data,xx,jgt,TickJieguo,Pname,FF,txfznum,txzhenji,dep1,fwcs,tname);
            end
        end
    end
end
strtmp={'已经按默认文件名保存完毕';['可在',Pname,'下找到']};
msgbox(strtmp,'处理完毕');