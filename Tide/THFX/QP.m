%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%C                        QP.FOR                                       C
%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
function P=QP(SG,CG)
if abs(CG)<1*10^(-32)
    if(SG>0)        
        P=pi/2;
    else
        P=-pi/2;
    end
else
    P=atan(SG/CG);
    if abs(P)<1*10^(-32)
        if(CG<0)
            P=P+pi;
        else
            if P*SG>0
            else
                P=P+pi;
            end
        end
    end
end