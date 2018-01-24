% --------------------------------------------------------------------
%  PAS_FD_Filt_Digital_Callback(hObject, eventdata, handles)
%  Butterworth�����˲���
% --------------------------------------------------------------------
function PAS_FD_Filt_Digital_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Filt_Digital (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%
depCS=struct('QS','999999','SP','60');
prompt={'ȱ�����','�������ڣ��룩'};
titleinput='��������'; lines=1; resize='on';
hi=inputdlg(prompt,titleinput,lines,struct2cell(depCS),resize);
if length(hi)<1
    return;
end
QS=str2double(hi{1});
SP=str2double(hi{2});
FH=1/SP/2;%����Ƶ��
%��������ѡ��
dnl=1;
[in1,valuel]=listdlg('Name','�����˲���','PromptString','ѡ����Ҫ���˲���','SelectionMode',...
    'Multiple','ListString',{'��ͨ�˲�','��ͨ�˲�','��ͨ�˲�','�����˲�'},...
    'InitialValue',dnl,'ListSize',[200 150]);
if valuel==0
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%
if sum(in1==1)%��ͨ�˲�
    depCS=struct('EPH','14400','NNH','7');
    prompt={'��ͨ��ֹ���ڣ��룩','Butterworth�˲�����'};
    titleinput='��������'; lines=1; resize='on';
    hi=inputdlg(prompt,titleinput,lines,struct2cell(depCS),resize);
    if length(hi)<1
        return;
    end
    EPH=str2double(hi{1});
    NNH=str2double(hi{2});
    FEH=1/EPH;%��ֹƵ��
    [BH,AH]=butter(NNH,FEH/FH,'high');
    [h,w]=freqz(BH,AH);
    ff=w*FH/pi;
    pp=1./ff;
    figure;
    plot(pp,abs(h)); grid;
    title('Amplitude Response (High Pass)');
    xlabel('Period (Second)'); ylabel('Amplitude');
end
if sum(in1==2)%��ͨ�˲�
    depCS=struct('EPL','14400','NNL','7');
    prompt={'��ͨ��ֹ���ڣ��룩','Butterworth�˲�����'};
    titleinput='��������'; lines=1; resize='on';
    hi=inputdlg(prompt,titleinput,lines,struct2cell(depCS),resize);
    if length(hi)<1
        return;
    end
    EPL=str2double(hi{1});
    NNL=str2double(hi{2});
    FEL=1/EPL;%��ֹƵ��
    [BL,AL]=butter(NNL,FEL/FH,'low');
    [h,w]=freqz(BL,AL);
    ff=w*FH/pi;
    pp=1./ff;
    figure;
    plot(pp,abs(h)); grid;
    title('Amplitude Response (Low Pass)');
    xlabel('Period (Second)'); ylabel('Amplitude');
end
if sum(in1==3)%��ͨ�˲�
    depCS=struct('EPBP','28800,14400','NNBP','5');
    prompt={'��ͨ��ֹ���ڣ��룩','Butterworth�˲�����'};
    titleinput='��������'; lines=1; resize='on';
    hi=inputdlg(prompt,titleinput,lines,struct2cell(depCS),resize);
    if length(hi)<1
        return;
    end
    EPBP=str2num(hi{1});
    NNBP=str2double(hi{2});
    FEBP=1./EPBP;%��ֹƵ��
    [BBP,ABP]=butter(NNBP,FEBP/FH);
    [h,w]=freqz(BBP,ABP);
    ff=w*FH/pi;
    pp=1./ff;
    figure;
    plot(pp,abs(h)); grid;
    title('Amplitude Response (Band Pass)');
    xlabel('Period (Second)'); ylabel('Amplitude');
end
if sum(in1==4)%�����˲�
    depCS=struct('EPBS','28800,14400','NNBS','5');
    prompt={'�����ֹ���ڣ��룩','Butterworth�˲�����'};
    titleinput='��������'; lines=1; resize='on';
    hi=inputdlg(prompt,titleinput,lines,struct2cell(depCS),resize);
    if length(hi)<1
        return;
    end
    EPBS=str2num(hi{1});
    NNBS=str2double(hi{2});
    FEBS=1./EPBS;%��ֹƵ��
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




%S0h2=filter(b2,a2,data);   %�������źŽ����˲�
