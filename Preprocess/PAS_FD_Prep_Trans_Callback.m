% --------------------------------------------------------------------
%  PAS_FD_Prep_Trans_Callback(hObject,eventdata,handles)
%  ��ͬ��ʽ������ת��
% --------------------------------------------------------------------
function PAS_FD_Prep_Trans_Callback(hObject,eventdata,handles)
% hObject    handle to PAS_FD_Prep_Common (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��������ѡ��
dnl=1;
[inl,valuel]=listdlg('Name','��ʽת��ѡ��','PromptString','ѡ����еĴ���','SelectionMode',...
    'Single','ListString',{'�������ݵ���->2������','ȥ�������ļ�ͷ','���ݹ�����xml�ļ�->2������'},...
    'InitialValue',dnl,'ListSize',[200 150]);
if valuel==0
    return;
end
if inl==2
    %�����趨
    depfw=struct('LofH','4');
    prompt={'�ļ�ͷ����'};
    title='�趨����ȥ�����ļ�ͷ����'; resize='off';
    hi=inputdlg(prompt,title,[1 100],struct2cell(depfw),resize);
    if isempty(hi)
        return;
    end
    fields={'LofH'};
    if size(hi,1)>0 
        depfw=cell2struct(hi,fields,1); 
    end
    fwcs=str2num(depfw.LofH);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ļ���
[Fname,Pname]=uigetfile({'*.txt','txt�ļ�(*.txt)';'*.dat','dat�ļ�(*.dat)';'*.xml','xml�ļ�(*.xml)';'*.*','���з���Ҫ����ļ�(*.*)'},'����ѡ��������ļ�','MultiSelect','on');
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

hw=waitbar(0,'Ԥ������...','Name',['��',num2str(NFZ),'���ļ�']);
tic;%��ʼ��ʱ
for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];
    FF=Fname{iiNFZ};
    if inl==1%�������ݵ���->2������
        tmp=load(dbfile); [~,N]=size(tmp);
        if N==25%����ֵ
            dataz=tmp(:,2:25);    timet=tmp(:,1);
            dataz=dataz';
            dataz=dataz(:);
            aa=timet*100;
            aa=repmat(aa,1,24);
            bb=0:1:23;
            bb=repmat(bb,size(aa,1),1);
            timet=aa+bb;
            timet=timet';
            timet=timet(:);
            %���
            f_nn=find(FF=='.')-1;
            outname=strcat(Pname,FF(1:f_nn),'_Trans','.txt');
            fm='%i %.5f\n';
            fidof=fopen(outname,'wt');
            fprintf(fidof,fm,[timet';dataz']);
            fclose(fidof);
        else
        end
    elseif inl==2%ȥ�������ļ�ͷ
        fidif=fopen(dbfile,'r');
        for qq=1:1:fwcs(1)%ȥ�ļ�ͷ
            tmpl=fgetl(fidif);
        end
        tmp=fscanf(fidif,'%i %f');
        %���
        f_nn=find(FF=='.')-1;
        outname=strcat(Pname,FF(1:f_nn),'_Trans','.txt');
        fm='%i %.5f\n';
        fidof=fopen(outname,'wt');
        fprintf(fidof,fm,tmp');
        fclose(fidif);
        fclose(fidof);
    elseif inl==3%���ݹ�����xml�ļ�->2������
        fidif=fopen(dbfile,'r');
        if strcmp(FF(14:16),'Cyu')%Ԥ��������
            TimeStr='<starttime>';
            hhz='Cyu';
        elseif strcmp(FF(14:16),'Cys')%ԭʼ����
            TimeStr='<sampletime';
            hhz='Cys';
        else
            continue;
        end
        timez=[];
        dataz=[];
        for qq=1:1:4%ȥ�ļ�ͷ
            tmpl=strtrim(fgetl(fidif));
        end
        XS=find(tmpl=='>',1)+1;
        Ftzh=tmpl(XS:XS+4);%̨վ��
        tmpl=strtrim(fgetl(fidif));
        XS=find(tmpl=='>',1)+1;
        Fcdh=tmpl(XS);%����
        tmpl=strtrim(fgetl(fidif));
        XS=find(tmpl=='>',1)+1;
        Fcxh=tmpl(XS:XS+3);%�����
        tmpl=strtrim(fgetl(fidif));
        XS=find(tmpl=='>',1)+1;
        Fcyl=str2num(tmpl(XS:XS+1));%������
        if Fcyl==1%����ֵ
            houzhui='��';
            geshu=1440;
        elseif Fcyl==60%����ֵ
            houzhui='ʱ';
            geshu=24;
        elseif Fcyl==90%�վ�ֵ
            houzhui='��';
            geshu=1;
        else
        end
        while(~feof(fidif))
            tmpl=strtrim(fgetl(fidif));
            if length(tmpl)>11
                if strcmp(tmpl(1:11),TimeStr)
                    XS=find(tmpl=='>',1)+1;
                    ttime=str2num(tmpl(XS:XS+3))*10000+str2num(tmpl(XS+5:XS+6))*100+str2num(tmpl(XS+8:XS+9));
                elseif strcmp(tmpl(1:6),'<data>')
                    tdata=str2num(tmpl(7:end-7))';
                    if geshu==length(tdata)
                        if geshu==1
                        elseif geshu==24
                            aa=repmat(ttime*100,1,24);
                            bb=0:1:23;
                            ttime=aa+bb;
                            ttime=ttime(:);
                        elseif geshu==1440
                            aa=repmat(ttime*10000,1,24*60)';
                            bb=0:1:23;
                            bb=repmat(bb,60,1)*100;
                            bb=bb(:);
                            cc=0:1:59;
                            cc=repmat(cc,1,24)';
                            ttime=aa+bb+cc;
                        end
                        timez=[timez;ttime];
                        dataz=[dataz;tdata];
                    else
                        break;
                    end
                else
                    continue;
                end
            else
                continue
            end
        end
        fclose(fidif);
        if ~isempty(dataz)
            %���
            fno=[Ftzh,'_',Fcdh,'_',Fcxh,'_',houzhui,'_',hhz];
            outname=strcat(Pname,fno,'_Trans','.txt');
            fm='%i %.5f\n';
            fidof=fopen(outname,'wt');
            [~,ind]=sort(timez,'ascend');
            outdd=[timez(ind)';dataz(ind)'];
            fprintf(fidof,fm,outdd);
            fclose(fidof);
        end
    else
    end
    waitbar(iiNFZ/NFZ,hw);
end
close(hw);
ttu=toc/60;
strtmp=['ѡ��',num2str(NFZ),'���ļ��������ļ�������',Pname,'�� �ļ�����׺Ϊ_Trans.txt������ʱ',num2str(ttu),'����'];
msgbox(strtmp,'�������');