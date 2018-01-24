function PhaseLout=XWLX(PhaseL)
%使相位滞后结果尽量变化平稳连续
[Ln,Rn]=size(PhaseL);
PhaseLout=[];
for ii=1:1:Rn
    datatmp=PhaseL(:,ii);
    outdata=datatmp;
    len=length(datatmp);    
    jj=1;
    while(jj<len)
        if isnan(datatmp(jj))
            jj=jj+1;            continue;
        else
            istart=jj;            iend=len;
            for mm=jj+1:1:len
                if isnan(datatmp(mm))
                    continue;
                else
                    iend=mm;                    break;
                end
            end
        end        
        dd=datatmp(iend)-datatmp(istart);
        tmp=[abs(dd-360);abs(dd);abs(dd+360)];
        [a,b]=min(tmp);        
        outdata(iend:len)=outdata(iend:len)+(b-2)*360;        
        jj=iend;
    end
    PhaseLout=[PhaseLout,outdata];
end
end