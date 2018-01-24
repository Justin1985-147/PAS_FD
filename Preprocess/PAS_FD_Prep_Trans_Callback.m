% --------------------------------------------------------------------
%  PAS_FD_Prep_Trans_Callback(hObject,eventdata,handles)
%  不同格式的数据转换
% --------------------------------------------------------------------
function PAS_FD_Prep_Trans_Callback(hObject,eventdata,handles)
% hObject    handle to PAS_FD_Prep_Common (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%处理类型选择
dnl=1;
[inl,valuel]=listdlg('Name','格式转换选择','PromptString','选择进行的处理','SelectionMode',...
    'Single','ListString',{'单天数据单行->2列数据','去掉多余文件头','数据共享网xml文件->2列数据'},...
    'InitialValue',dnl,'ListSize',[200 150]);
if valuel==0
    return;
end
if inl==2
    %参数设定
    depfw=struct('LofH','4');
    prompt={'文件头行数'};
    title='设定所需去掉的文件头行数'; resize='off';
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
%读文件名
[Fname,Pname]=uigetfile({'*.txt','txt文件(*.txt)';'*.dat','dat文件(*.dat)';'*.xml','xml文件(*.xml)';'*.*','所有符合要求的文件(*.*)'},'请挑选待处理的文件','MultiSelect','on');
%完整文件路径
if iscell(Fname)
    NFZ=length(Fname);
elseif Fname==0  %如果没有打开文件，则跳出程序
    return;
else
    NFZ=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if NFZ==1%一个文件
    Fname={Fname};
end

hw=waitbar(0,'预处理中...','Name',['共',num2str(NFZ),'个文件']);
tic;%开始计时
for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];
    FF=Fname{iiNFZ};
    if inl==1%单天数据单行->2列数据
        tmp=load(dbfile); [~,N]=size(tmp);
        if N==25%整点值
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
            %输出
            f_nn=find(FF=='.')-1;
            outname=strcat(Pname,FF(1:f_nn),'_Trans','.txt');
            fm='%i %.5f\n';
            fidof=fopen(outname,'wt');
            fprintf(fidof,fm,[timet';dataz']);
            fclose(fidof);
        else
        end
    elseif inl==2%去掉多余文件头
        fidif=fopen(dbfile,'r');
        for qq=1:1:fwcs(1)%去文件头
            tmpl=fgetl(fidif);
        end
        tmp=fscanf(fidif,'%i %f');
        %输出
        f_nn=find(FF=='.')-1;
        outname=strcat(Pname,FF(1:f_nn),'_Trans','.txt');
        fm='%i %.5f\n';
        fidof=fopen(outname,'wt');
        fprintf(fidof,fm,tmp');
        fclose(fidif);
        fclose(fidof);
    elseif inl==3%数据共享网xml文件->2列数据
        fidif=fopen(dbfile,'r');
        if strcmp(FF(14:16),'Cyu')%预处理数据
            TimeStr='<starttime>';
            hhz='Cyu';
        elseif strcmp(FF(14:16),'Cys')%原始数据
            TimeStr='<sampletime';
            hhz='Cys';
        else
            continue;
        end
        timez=[];
        dataz=[];
        for qq=1:1:4%去文件头
            tmpl=strtrim(fgetl(fidif));
        end
        XS=find(tmpl=='>',1)+1;
        Ftzh=tmpl(XS:XS+4);%台站号
        tmpl=strtrim(fgetl(fidif));
        XS=find(tmpl=='>',1)+1;
        Fcdh=tmpl(XS);%测点号
        tmpl=strtrim(fgetl(fidif));
        XS=find(tmpl=='>',1)+1;
        Fcxh=tmpl(XS:XS+3);%测项号
        tmpl=strtrim(fgetl(fidif));
        XS=find(tmpl=='>',1)+1;
        Fcyl=str2num(tmpl(XS:XS+1));%采样率
        if Fcyl==1%分钟值
            houzhui='分';
            geshu=1440;
        elseif Fcyl==60%整点值
            houzhui='时';
            geshu=24;
        elseif Fcyl==90%日均值
            houzhui='日';
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
            %输出
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
strtmp=['选中',num2str(NFZ),'个文件处理后的文件保存在',Pname,'， 文件名后缀为_Trans.txt，共耗时',num2str(ttu),'分钟'];
msgbox(strtmp,'处理完毕');