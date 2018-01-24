% --------------------------------------------------------------------
%  PAS_FD_Filt_Digital_Callback(hObject, eventdata, handles)
%  ��������time-data��ʽ�Ķ�ά����
% --------------------------------------------------------------------
function PAS_FD_Plots_Single_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_Plots_Single (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%
%���ļ���
[Fname,Pname]=uigetfile({'*.*','ʱ����������(*.*)'},'����ѡ����ͼ���ļ�','MultiSelect','on');
%�����ļ�·��
if iscell(Fname)
    NFZ=length(Fname);
elseif Fname==0  %���û�д��ļ�������������
    return;
else
    NFZ=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
canshu=handles.canshu.canshu11;
if canshu{1}==1
    dnFW=[1];
    [inFW,valueFW]=listdlg('PromptString','�Ƿ�Ի�ͼ��Χ�����޶�','SelectionMode',...
        'Single','ListString',{'��','������׼���޶�','ֱ�Ӹ�����Χ'},...
        'InitialValue',dnFW,'ListSize',[200 250]);
    if valueFW==0
        return;
    end
    if inFW==2
        depfw=struct('bs','6');
        prompt={'����������׼������ݵ㲻���'};
        title='��ͼ��Χ�޶�'; lines=1; resize='on';
        hi=inputdlg(prompt,title,lines,struct2cell(depfw),resize);
        if isempty(hi)
            return;
        end
        fields={'bs'};
        if size(hi,1)>0 depfw=cell2struct(hi,fields,1); end
        fwcs=[str2num(depfw.bs),NaN,NaN];
    elseif inFW==3
        depfw=struct('yxmi','0','yxma','1');
        prompt={'y������Сֵ','y�������ֵ'};
        title='��ͼ��Χ�޶�'; lines=1; resize='on';
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
    dep1=struct('QS','999999','YL','Ӧ��(10^{-10})');
    prompt={'�����е�ȱ�����','y��label'};
    title='��������'; lines=1; resize='off';
    hi1=inputdlg(prompt,title,lines,struct2cell(dep1),resize);
    if isempty(hi1)
        return;
    end
    fields={'QS','YL'};
    if size(hi1,1)>0 dep1=cell2struct(hi1,fields,1); end
    dnxx=[1];
    [inxx,valuexx]=listdlg('PromptString','ѡ����������','SelectionMode',...
        'Single','ListString',{'ʵ��-','����:','�㻮��.-','����--','ɢ��'},...
        'InitialValue',dnxx,'ListSize',[200 250]);
    if valuexx==0
        return;
    end
    dnxc=[1];
    [inxc,valuexc]=listdlg('PromptString','ѡ��������ɫ','SelectionMode',...
        'Single','ListString',{'��ɫ','��ɫ','��ɫ','��ɫ'},...
        'InitialValue',dnxc,'ListSize',[200 250]);
    if valuexc==0
        return;
    end
    dnxb=[2];
    [inxb,valuexb]=listdlg('PromptString','�Ƿ����y=0�Ļ�׼��','SelectionMode',...
        'Single','ListString',{'��','��'},...
        'InitialValue',dnxb,'ListSize',[200 250]);
    if valuexb==0
        return;
    end
    QS=str2num(dep1.QS);
else
    fwcs=str2num(cell2mat(canshu(2:4)'));
    yl=canshu{6};
    if length(yl)==1&&yl=='��'
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
if NFZ==1%һ���ļ������ļ���ȡ��Щ���
    Fname={Fname};
end
load('Station.mat');
for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];        drsj=load(dbfile); %��������
    [~,N]=size(drsj);
    %��������������ݣ��������ļ�
    if N~=2
        continue;
    end
    %%%%%%%%%%%%%%%%%%%%%%%
    FF=Fname{iiNFZ};
    if length(FF)<12
        tname='';%ͼ��
    else
        cx=strmatch(FF(9:12),SFLDM);%�жϲ����Ƿ���������ñ���
        if isempty(cx)
            tname='';%ͼ��
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
    %[data,timej]=FillGap(data,timej,QS);%�����
    data(data==QS)=NaN;%�滻ȱ��ΪNaN�����ڻ�ͼ
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %�̶ȼ�labelλ��
    stdate=timej(1);%��һ��ʱ��
    etdate=timej(end);%���һ��ʱ��
    ttp=length(num2str(timej(1)));%ʱ��λ��
    if ttp==8
        yy=floor(timej/1e4);%��
        mm=mod(floor(timej/1e2),1e2);%��
        dd=mod(timej,1e2);%��
        xx=datenum([yy,mm,dd]);
        tend=timej(end);
    elseif ttp==10
        yy=floor(timej/1e6);%��
        mm=mod(floor(timej/1e4),1e2);%��
        dd=mod(floor(timej/1e2),1e2);%��
        HH=mod(timej,1e2);%Сʱ
        xx=datenum([yy,mm,dd,HH,zeros(length(yy),2)]);
        tend=fix(timej(end)/100);
    elseif ttp==12
        yy=floor(timej/1e8);%��
        mm=mod(floor(timej/1e6),1e2);%��
        dd=mod(floor(timej/1e4),1e2);%��
        HH=mod(floor(timej/1e2),1e2);%Сʱ
        MM=mod(timej,1e2);%����
        xx=datenum([yy,mm,dd,HH,MM,zeros(length(yy),1)]);
        tend=fix(timej(end)/10000);
    end
    styy=mm(1);%��һ���·�
    stnn=yy(1);%��һ�����
    ys=floor((xx(end)-xx(1))/30)+1;%��������
    
    jgt=round(ys/12);%ȡ��������Ϊminortick���,1����������Ϊ�����2��������2��Ϊ���
    if jgt==5
        jgt=4;
    elseif jgt==0
        jgt=1;
    elseif jgt>5
        jgt=12*ceil(ys/120);%6����������ֱ����һ��tick
    end
    
    TickJieguo=FHXtick(jgt,stnn,styy,tend);%����tick��label
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
strtmp={'�Ѿ���Ĭ���ļ����������';['����',Pname,'���ҵ�']};
msgbox(strtmp,'�������');