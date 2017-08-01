function do_stbow(config_file)


%% By Xiangang Cheng, CeMNeT, NTU, SG
%% xiangang@pmail.ntu.edu.sg
%% 23/MAR/2010

%% Evaluate global configuration file
EXPTYPE = 'stbow';
eval(config_file);

clc

%% How many instances are we processing?
NUM = length(STBOW.fnames);
tic;
%%% Loop over all images....
for i=1:NUM
    if(~mod(i,10))
        fprintf('.%d',i);
        if(~mod(i,100))
            fprintf('\n');
        end;
    end;
    
    fileName = [STBOW.VQ_Dir,STBOW.subdir{i},filesep, STBOW.fnames{i},'_uncomp.mat'];
    try
        load(fileName, 'descriptor_vq');
    catch
        error('Error Reading %s\n', fileName);
    end;
    
    lvlIdx = floor(descriptor_vq(2,:)/(STBOW.height/3))+1;
    
    
    for fIdx = 1 : 4
        if(STBOW.frameIdx((fIdx-1)*2+1))
            curfrange = descriptor_vq(3,:)>STBOW.frameIdx(i, (fIdx-1)*2+1)&descriptor_vq(3,:)<STBOW.frameIdx(i,2*fIdx);
            stbowfeat = [];

            switch STBOW.lvlType
                case 0
                    %%no level infor
                    curdesc =descriptor_vq(4, curfrange);
                    curfeat =hist(curdesc, 1:STBOW.vqSize);
                    stbowfeat = [stbowfeat,curfeat];
                case 1
                    %level 3x1x1
                    for ii = 1:3
                        curdesc =descriptor_vq(4, lvlIdx == ii&curfrange);
                        curfeat =hist(curdesc, 1:STBOW.vqSize);
                        stbowfeat = [stbowfeat,curfeat];
                    end;
                otherwise
                    error('Please select the right lvl partition. Unknown type %d', STBOW.lvlType);
            end;
            %%% normalize the histogram
            stbowfeat = stbowfeat/sum(stbowfeat);%/length(curfrange);
            
            save([STBOW.feat_Dir, STBOW.fnames{i},'_',num2str(fIdx),'.mat'], 'stbowfeat');
        end;%if(STBOW.frameIdx((fIdx-1)*2+1))
    end;
    
end

total_time=toc;

fprintf('\nFinished running STBOW process\n');
fprintf('Total number of images: %d, mean time per image: %f secs\n',NUM,total_time/NUM);




