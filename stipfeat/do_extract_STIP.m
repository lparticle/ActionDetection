function do_extract_STIP(config_file)

%% By Xiangang Cheng, CeMNeT, NTU, SG
%% xiangang@pmail.ntu.edu.sg
%% 29/Mar/2010

%% Evaluate global configuration file
EXPTYPE = 'stipfeat';
eval(config_file);

cd([cd, '\stipfeat\']);

subfolder = dir(VIDEO.dir);

N = length(subfolder);

for i = 3:N
    if(subfolder(i).isdir)
        infolder = [VIDEO.dir, subfolder(i).name, filesep];
        outfolder = [Feat.dir,subfolder(i).name, filesep];
        if(~exist(outfolder, 'dir'))
            mkdir(outfolder);
        end;
        if(i<N)
            dos([extractor, detector, infolder, ' ', outfolder, ' 0 ', descriptor, option, ' &']);
        else
            dos([extractor, detector, infolder, ' ', outfolder, ' 0 ', descriptor, option, ' &']);
        end;
    end;
end;

    
    
