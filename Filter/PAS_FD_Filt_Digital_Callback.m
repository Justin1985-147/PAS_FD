% --------------------------------------------------------------------
%  PAS_FD_Filt_Digital_Callback(hObject, eventdata, handles)
%  Butterworth数字滤波器
% --------------------------------------------------------------------
function PAS_FD_Filt_Digital_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Filt_Digital (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%
depCS=struct('QS','999999','SP','60');
prompt={'缺数标记','采样周期（秒）'};
titleinput='基本参数'; lines=1; resize='on';
hi=inputdlg(prompt,titleinput,lines,struct2cell(depCS),resize);
if length(hi)<1
    return;
end
QS=str2double(hi{1});
SP=str2double(hi{2});
FH=1/SP/2;%分析频率
%处理类型选择
dnl=1;
[in1,valuel]=listdlg('Name','数字滤波器','PromptString','选择需要的滤波器','SelectionMode',...
    'Multiple','ListString',{'高通滤波','低通滤波','带通滤波','带阻滤波'},...
    'InitialValue',dnl,'ListSize',[200 150]);
if valuel==0
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%
if sum(in1==1)%高通滤波
    depCS=struct('EPH','14400','NNH','7');
    prompt={'高通截止周期（秒）','Butterworth滤波阶数'};
    titleinput='基本参数'; lines=1; resize='on';
    hi=inputdlg(prompt,titleinput,lines,struct2cell(depCS),resize);
    if length(hi)<1
        return;
    end
    EPH=str2double(hi{1});
    NNH=str2double(hi{2});
    FEH=1/EPH;%截止频率
    [BH,AH]=butter(NNH,FEH/FH,'high');
    [h,w]=freqz(BH,AH);
    ff=w*FH/pi;
    pp=1./ff;
    figure;
    plot(pp,abs(h)); grid;
    title('Amplitude Response (High Pass)');
    xlabel('Period (Second)'); ylabel('Amplitude');
end
if sum(in1==2)%低通滤波
    depCS=struct('EPL','14400','NNL','7');
    prompt={'低通截止周期（秒）','Butterworth滤波阶数'};
    titleinput='基本参数'; lines=1; resize='on';
    hi=inputdlg(prompt,titleinput,lines,struct2cell(depCS),resize);
    if length(hi)<1
        return;
    end
    EPL=str2double(hi{1});
    NNL=str2double(hi{2});
    FEL=1/EPL;%截止频率
    [BL,AL]=butter(NNL,FEL/FH,'low');
    [h,w]=freqz(BL,AL);
    ff=w*FH/pi;
    pp=1./ff;
    figure;
    plot(pp,abs(h)); grid;
    title('Amplitude Response (Low Pass)');
    xlabel('Period (Second)'); ylabel('Amplitude');
end
if sum(in1==3)%带通滤波
    depCS=struct('EPBP','28800,14400','NNBP','5');
    prompt={'带通截止周期（秒）','Butterworth滤波阶数'};
    titleinput='基本参数'; lines=1; resize='on';
    hi=inputdlg(prompt,titleinput,lines,struct2cell(depCS),resize);
    if length(hi)<1
        return;
    end
    EPBP=str2num(hi{1});
    NNBP=str2double(hi{2});
    FEBP=1./EPBP;%截止频率
    [BBP,ABP]=butter(NNBP,FEBP/FH);
    [h,w]=freqz(BBP,ABP);
    ff=w*FH/pi;
    pp=1./ff;
    figure;
    plot(pp,abs(h)); grid;
    title('Amplitude Response (Band Pass)');
    xlabel('Period (Second)'); ylabel('Amplitude');
end
if sum(in1==4)%带阻滤波
    depCS=struct('EPBS','28800,14400','NNBS','5');
    prompt={'带阻截止周期（秒）','Butterworth滤波阶数'};
    titleinput='基本参数'; lines=1; resize='on';
    hi=inputdlg(prompt,titleinput,lines,struct2cell(depCS),resize);
    if length(hi)<1
        return;
    end
    EPBS=str2num(hi{1});
    NNBS=str2double(hi{2});
    FEBS=1./EPBS;%截止频率
    [BBS,ABS]=butter(NNBS,FEBS/FH,'stop');
    [h,w]=freqz(BBS,ABS);
    ff=w*FH/pi;
    pp=1./ff;
    figure;
    plot(pp,abs(h)); grid;
    title('Amplitude Response (Band Stop)');
    xlabel('Period (Second)'); ylabel('Amplitude');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%




%S0h2=filter(b2,a2,data);   %对输入信号进行滤波
