%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%C                        QN.FOR                                       C
%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
function C=QN(D,N)
%����
C=D;
for I=1:N
    C(I,I)=C(I,I)+1;
end
for K=1:N
    P=C(K,K)-1;
    if abs(P)<10^(-32)%�����Ԫ��Ϊ0��ֱ�Ӹ�ֵΪNaN����������
        %disp('THE MAIN ELEMENT IS EQUAL TO ZERO');
        C=NaN*C;
        return;
    else
    end
    for J=1:N
        C(K,J)=C(K,J)/P;
    end
    for I=1:N
        if I==K
            continue;
        else
            Q=C(I,K);
            for J=1:N
                C(I,J)=C(I,J)-Q*C(K,J);
            end
        end
    end
end
for I=1:N
    C(I,I)=C(I,I)-1;
end
end