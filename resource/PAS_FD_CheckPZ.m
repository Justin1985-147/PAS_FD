function canshu=PAS_FD_CheckPZ(hObject, eventdata, handles)
FIDpz=fopen('PAS�����ļ�.log','r');
while ~feof(FIDpz)
    tmp=fgetl(FIDpz);
    switch tmp(1)
        case '#'
            continue;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case '1'%��ͼ
            switch tmp(3)
                case '1'%һ�����߻���
                    while ~feof(FIDpz)
                        tmp=fgetl(FIDpz);
                        switch tmp(1)
                            case '#'
                                continue;
                            case '0'
                                canshu11=strsplit(tmp,',');
                                if length(canshu11)<11
                                    errordlg('һ���������õĲ�������������');
                                    fclose(FIDpz);
                                    return;
                                end
                                canshu11=canshu11(2:end);
                                break;
                            otherwise
                                errordlg('ȱ��һ���������õĲ����У�');
                                fclose(FIDpz);
                                return;
                        end
                    end
                otherwise
                    errordlg('������û�еĲ˵��');
                    fclose(FIDpz);
                    return;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        otherwise
            errordlg('������û�еĲ˵��');
            fclose(FIDpz);
            return;
    end
end
canshu.canshu11=canshu11;
fclose(FIDpz);