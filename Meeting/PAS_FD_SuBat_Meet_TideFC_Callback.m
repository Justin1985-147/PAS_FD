% --------------------------------------------------------------------
%  PAS_FD_SuBat_Meet_TideFC_Callback(hObject, eventdata, handles)
%  ���������ڳ�ϫ���ӵĸ��٣�׷���½����
% --------------------------------------------------------------------
function PAS_FD_SuBat_Meet_TideFC_Callback(hObject, eventdata, handles)
% hObject    handle to PAS_FD_SuBat_Meet_TideF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%˵������Ϊ���ݾ�����Ԥ����,������׷��
%�������ļ���
Pname=uigetdir(pwd,'ѡ�������ļ�����Ŀ¼');
if Pname==0
    return;
end
FnameT=struct2cell(dir(Pname));
ID=cell2mat(FnameT(4,:));
Fname=FnameT(1,~ID);
if isempty(Fname)
    return;%�������ļ�������
end
%������ļ���
OPname=uigetdir(pwd,'ѡ�����ļ�����Ŀ¼');
if OPname==0
    return;
end
FnameT=struct2cell(dir(OPname));
ID=cell2mat(FnameT(4,:));
OFname=FnameT(1,~ID);%����Ϊ��
Fname=cell2mat(Fname');
OFname=cell2mat(OFname');
%%%%%%%%%%%%%%%
hw=waitbar(0,'��ϫ���Ӹ��ټ�����...','Name',['��',num2str(size(OFname,1)),'���ļ�']);
tic;%��ʼ��ʱ
upnoF=0;%���µĽ���ļ���
for ii=1:1:size(OFname,1)%�Խ���ļ�Ϊ׼��ֻ����֮ǰ���ڵ��ļ�
    [~,jj,~] = intersect(Fname(:,1:12),OFname(ii,4:15),'rows');
    if ~isempty(jj)%�������ļ�
        dbfile1=[Pname,'\',Fname(jj,:)];
        dbfile2=[OPname,'\',OFname(ii,:)];
        tmp=load(dbfile1);
        load(dbfile2);
        %̨վ������Ϣ
        dep.HH=HH;
        dep.AZ=AZ;
        dep.FB=FB;
        dep.FL=FL;
        %���������Ϣ
        dep.IHS=IHS;
        dep.IZL=IZL;
        dep.IBOL=IBOL;
        dep.IBIAO=IBIAO;
        dep.IJG=IJG;
        %��������
        dep.CCH=CCH;
        dep.BCH=BCH;
        dep.WZ=WZ;
        %������Ϣ
        dep.SCF=SCF;
        dep.QS=QS;
        %�����ݵ����һ����������Ҫ����LastDate����Ҫ����
        LastDate=str2num(datestr(datenum(num2str(timej(end)),'yyyymmdd')+BCH+CCH-WZ,'yyyymmdd'));
        dataz=tmp(:,2);    timet=tmp(:,1);
        if timet(end)>=LastDate*100+23;%�б�Ҫ����
            FirstDate=str2num(datestr(datenum(num2str(timej(end)),'yyyymmdd')+BCH+1-WZ,'yyyymmdd'));%��FirstDate��ʼ��ȡ���ݽ��м���
            ind=find(timet==FirstDate*100);
            dataz=dataz(ind:end);
            timet=timet(ind:end);
            %��λ����
            dataz(dataz~=QS)=dataz(dataz~=QS)*SCF;
            %
            result.Factor=Factor;
            result.Msf=Msf;
            result.PhaseL=PhaseL;
            result.Msp=Msp;
            result.timej=timej;
            result.FBM=FBM;
            %
            timeuz=unique(fix(timet/100));%���յ�ʱ������
            handles.canshu=dep; handles.shuju=dataz;
            handles.shijian=timeuz;
            handles.result=result;
            handles.outname=dbfile2;
            THFXLQm(handles);
            upnoF=upnoF+1;%���µĽ���ļ���
        end
    end
    waitbar(ii/size(OFname,1),hw);
end
close(hw);
ttu=toc/60;
strtmp=['��',num2str(size(OFname,1)),'������ļ���','������',OPname,'������ʱ',num2str(ttu),'���ӣ�����',num2str(upnoF),'������ļ������˸���'];
msgbox(strtmp,'�������');