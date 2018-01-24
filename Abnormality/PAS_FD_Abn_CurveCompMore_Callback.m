% --------------------------------------------------------------------
%  PAS_FD_Abn_CurveCompMore_Callback(hObject, eventdata, handles)
%  �����в�����������ģ����̬���Ƶ�ʱ���
% --------------------------------------------------------------------
function PAS_FD_Abn_CurveCompMore_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Abn_CurveCompMore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ļ���
[Fname,Pname]=uigetfile({'*.txt','txt�ļ�(*.txt)';'*.dat','dat�ļ�(*.dat)';'*.*','���з���Ҫ����ļ�(*.*)'},'����ѡ�쳣����ģ�����ڵ��ļ�','MultiSelect','off');
%�����ļ�·��
if Fname==0  %���û�д��ļ�������������
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%
dbfile=[Pname,Fname];
tmp=load(dbfile); [~,N]=size(tmp);
%��������������ݣ��������ļ�
if N~=2
    msgbox('�����ļ���Ҫ��ͨ�õ����и�ʽ�����������ļ�','δ����');
    return;
else
    dataz=tmp(:,2);    timet=tmp(:,1);
    clear tmp;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%
stimet=num2str(timet);
[~,len2]=size(stimet);
if len2==14%��ֵ����
    strfor='yyyymmddHHMMSS';
elseif len2==12%����ֵ����
    strfor='yyyymmddHHMM';
elseif len2==10%����ֵ����
    strfor='yyyymmddHH';
elseif len2==8%��ֵ����
    strfor='yyyymmdd';
else
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%
depCS=struct('QS','999999','Range','2014080100,2014082023','StaCo','0.8','StaAm','0.1');
prompt={'ȱ�����','ģ�����߶ε�ʱ�䷶Χ�������������ѡ����մ˲�����','���ϵ����ֵ','��Է��Ȳ���ֵ'};
titleinput='��������'; lines=1; option.resize='on';option.windowstyle='normal';
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
    title('ͨ��zoom��ʾ��Ϊ�쳣ģ���ʱ��Σ�ȷ�Ϻ��밴�ո�');
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
%���ļ���
[Fname,Pname]=uigetfile({'*.txt','txt�ļ�(*.txt)';'*.dat','dat�ļ�(*.dat)';'*.*','���з���Ҫ����ļ�(*.*)'},'����ѡ���д��Աȵ��ļ�','MultiSelect','on');
%�����ļ�·��
if iscell(Fname)
    NFZ=length(Fname);
elseif Fname==0  %���û�д��ļ�������������
    return;
else
    NFZ=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if NFZ==1%һ���ļ�
    Fname={Fname};
end

j2NFZ=0;%����ͳ��ѡ�е�����������������Ҫ��δ������ļ�����
for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];
    FF=Fname{iiNFZ};
    tmp=load(dbfile); [~,N]=size(tmp);
    %��������������ݣ��������ļ�
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
    %���
    saveas(gcf,outname,'emf');
    saveas(gcf,outname,'fig');
    close(gcf);
end