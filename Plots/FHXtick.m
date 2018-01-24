%-----------------------------------------------------------
%返回自动选择的tick及label
%-----------------------------------------------------------
function TickJieguo=FHXtick(jgt,stnn,styy,ttend)
if jgt<12
    %6年以下数据用两种tick
    minors=[1:jgt:12];%minortick
    stwz=fix((styy-1)/jgt)+2;%画图时第一个tick在minortick中的位置
    lm=length(minors);        im=mod(stwz,lm);%画图时第一个tick在minortick中的位置，去掉重复周期
    ns=fix((stwz-1)/lm)+stnn;%画图时第一个tick对应的年份
    if im==0
        im=lm;
    end
    ss1=ns*10000+minors(im)*100+1;%第一个minortick对应的具体日期
    tp=ss1;        nst=ns;        mst=minors(im);
    pd=im;         ssnn=[];       ssyy=[];
    ii=1;          szm=[];
    while 1
        ssnn=[ssnn;nst];            ssyy=[ssyy;mst];
        if mst==1
            szm=[szm;ii]; %存放1月份在tick中的位置，为后面挑选主tick做准备
        end
        mpd=mod(pd,lm);
        if mpd==0
            nst=nst+1;                mst=minors(1);
        else
            mst=minors(mpd+1);
        end
        tp=nst*10000+mst*100+1;%依次每个minortick对应的具体日期
        if tp>ttend
            break;
        end
        pd=pd+1;             ii=ii+1;
    end
    %%所有minortick时刻
    ssdanum=datenum(ssnn,ssyy,ones(length(ssnn),1));
    xt=ssdanum;%minortick的位置
    xl=num2str(ssyy);%minortick的label
    xtm=xt(szm);%主tick的位置
    ml=num2str(ssnn(szm));%主ticklabel
    TickJieguo={xt,xl,xtm,ml,ns};
else
    %6年以上数据直接用一种tick
    nst=stnn+1;        ssnn=[];
    while 1
        ssnn=[ssnn;nst];            nst=nst+jgt/12;
        tp=nst*10000+101;
        if tp>ttend
            break;
        end
    end
    %%tick时刻
    ssdanum=datenum(ssnn,ones(length(ssnn),1),ones(length(ssnn),1));
    xt=ssdanum;%minortick的位置
    xl=num2str(ssnn);%tick的label
    TickJieguo={xt,xl};
end