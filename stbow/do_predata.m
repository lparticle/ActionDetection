function do_stbow(config_file)


%% By Xiangang Cheng, CeMNeT, NTU, SG
%% xiangang@pmail.ntu.edu.sg
%% 23/MAR/2010

%% Evaluate global configuration file
EXPTYPE = 'predata';
eval(config_file);

clc

%% How many instances are we processing?
NUM = length(STBOW.fnames);
tic;

trIdx = find(parameter.expsetting(:, 1));

trData = [];
trLabel= [];
%%% Loop over all images....
for i=1:length(trIdx)
    if(~mod(i,10))
        fprintf('.%d',i);
        if(~mod(i,100))
            fprintf('\n');
        end;
    end;
    
    for fIdx = 1 : 4
        if(STBOW.frameIdx((fIdx-1)*2+1)>0)
            
            load([STBOW.feat_Dir, STBOW.fnames{trIdx(i)},'_',num2str(fIdx),'.mat'], 'stbowfeat');
            trData = [trData; stbowfeat];
            trLabel = [trLabel; parameter.label(trIdx(i))];
        end;%if(STBOW.frameIdx((fIdx-1)*2+1))
    end;
    
end
save([STBOW.cFileName, '_train.mat'], 'trData', 'trLabel');


valIdx = find(parameter.expsetting(:, 2));

valData = [];
valLabel= [];
%%% Loop over all images....
for i=1:length(valIdx)
    if(~mod(i,10))
        fprintf('.%d',i);
        if(~mod(i,100))
            fprintf('\n');
        end;
    end;
    
    for fIdx = 1 : 4
        if(STBOW.frameIdx((fIdx-1)*2+1)>0)
            
            load([STBOW.feat_Dir, STBOW.fnames{valIdx(i)},'_',num2str(fIdx),'.mat'], 'stbowfeat');
            valData = [valData; stbowfeat];
            valLabel = [valLabel; parameter.label(valIdx(i))];
        end;%if(STBOW.frameIdx((fIdx-1)*2+1))
    end;
    
end
save([STBOW.cFileName, '_validation.mat'], 'valData', 'valLabel');

teIdx = find(parameter.expsetting(:, 3));

teData = [];
teLabel= [];
%%% Loop over all images....
for i=1:length(teIdx)
    if(~mod(i,10))
        fprintf('.%d',i);
        if(~mod(i,100))
            fprintf('\n');
        end;
    end;
    
    for fIdx = 1 : 4
        if(STBOW.frameIdx((fIdx-1)*2+1)>0)
            
            load([STBOW.feat_Dir, STBOW.fnames{teIdx(i)},'_',num2str(fIdx),'.mat'], 'stbowfeat');
            teData = [teData; stbowfeat];
            teLabel = [teLabel; parameter.label(teIdx(i))];
        end;%if(STBOW.frameIdx((fIdx-1)*2+1))
    end;
    
end
save([STBOW.cFileName, '_test.mat'], 'teData', 'teLabel');

fprintf('\nFinished preparing data process\n');





