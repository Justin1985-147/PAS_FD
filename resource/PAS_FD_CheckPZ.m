function canshu=PAS_FD_CheckPZ(hObject, eventdata, handles)
FIDpz=fopen('PAS配置文件.log','r');
while ~feof(FIDpz)
    tmp=fgetl(FIDpz);
    switch tmp(1)
        case '#'
            continue;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        case '1'%绘图
            switch tmp(3)
                case '1'%一般曲线绘制
                    while ~feof(FIDpz)
                        tmp=fgetl(FIDpz);
                        switch tmp(1)
                            case '#'
                                continue;
                            case '0'
                                canshu11=strsplit(tmp,',');
                                if length(canshu11)<11
                                    errordlg('一般曲线配置的参数个数不够！');
                                    fclose(FIDpz);
                                    return;
                                end
                                canshu11=canshu11(2:end);
                                break;
                            otherwise
                                errordlg('缺少一般曲线配置的参数行！');
                                fclose(FIDpz);
                                return;
                        end
                    end
                otherwise
                    errordlg('定义了没有的菜单项！');
                    fclose(FIDpz);
                    return;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        otherwise
            errordlg('定义了没有的菜单项！');
            fclose(FIDpz);
            return;
    end
end
canshu.canshu11=canshu11;
fclose(FIDpz);