%-----------------------------------------------------------
%�����Զ�ѡ���tick��label
%-----------------------------------------------------------
function TickJieguo=FHXtick(jgt,stnn,styy,ttend)
if jgt<12
    %6����������������tick
    minors=[1:jgt:12];%minortick
    stwz=fix((styy-1)/jgt)+2;%��ͼʱ��һ��tick��minortick�е�λ��
    lm=length(minors);        im=mod(stwz,lm);%��ͼʱ��һ��tick��minortick�е�λ�ã�ȥ���ظ�����
    ns=fix((stwz-1)/lm)+stnn;%��ͼʱ��һ��tick��Ӧ�����
    if im==0
        im=lm;
    end
    ss1=ns*10000+minors(im)*100+1;%��һ��minortick��Ӧ�ľ�������
    tp=ss1;        nst=ns;        mst=minors(im);
    pd=im;         ssnn=[];       ssyy=[];
    ii=1;          szm=[];
    while 1
        ssnn=[ssnn;nst];            ssyy=[ssyy;mst];
        if mst==1
            szm=[szm;ii]; %���1�·���tick�е�λ�ã�Ϊ������ѡ��tick��׼��
        end
        mpd=mod(pd,lm);
        if mpd==0
            nst=nst+1;                mst=minors(1);
        else
            mst=minors(mpd+1);
        end
        tp=nst*10000+mst*100+1;%����ÿ��minortick��Ӧ�ľ�������
        if tp>ttend
            break;
        end
        pd=pd+1;             ii=ii+1;
    end
    %%����minortickʱ��
    ssdanum=datenum(ssnn,ssyy,ones(length(ssnn),1));
    xt=ssdanum;%minortick��λ��
    xl=num2str(ssyy);%minortick��label
    xtm=xt(szm);%��tick��λ��
    ml=num2str(ssnn(szm));%��ticklabel
    TickJieguo={xt,xl,xtm,ml,ns};
else
    %6����������ֱ����һ��tick
    nst=stnn+1;        ssnn=[];
    while 1
        ssnn=[ssnn;nst];            nst=nst+jgt/12;
        tp=nst*10000+101;
        if tp>ttend
            break;
        end
    end
    %%tickʱ��
    ssdanum=datenum(ssnn,ones(length(ssnn),1),ones(length(ssnn),1));
    xt=ssdanum;%minortick��λ��
    xl=num2str(ssnn);%tick��label
    TickJieguo={xt,xl};
end