function do_vq(config_file)

%% Function takes the regions in interest_points directory, along with
%% their descirptors and vector-quantizes them using the codebook
%% specified in the VQ structure.


%% You must also have either: (a) run do_form_codebook to generate a codebook file
%%                        or: (b) already have a valid codebook file in
%% CODEBOOK_DIR, matching the VQ.Codebook_Type tag and of size VQ.Codebook_Size.


%% By Xiangang Cheng, CeMNeT, NTU, SG
%% xiangang@pmail.ntu.edu.sg
%% 13/10/2008

%% Evaluate global configuration file
EXPTYPE = 'codebook';
eval(config_file);

%% If no VQ structure specifying codebook
%% give some defaults

if ~exist('VQ')
    %% use default codebook family
    VQ.Codebook_Type = 'generic';
    %% 1000 words is standard setting
    VQ.Codebook_Size = 500;
end


clc


%% How many images are we processing?
nImages = length(VQ.fnames);

%% Now load up codebook
codebook_name = [VQ.CODEBOOK_DIR , '/', VQ.Codebook_Name];
load(codebook_name);

tic;

%%% Loop over all images....
for i=1:nImages
    if(~mod(i,10))
        fprintf('.%d',i);
        if(~mod(i,100))
            fprintf('\n');
        end;
    end;

    %%% Load up interest point file
    %     feature = dlmread([VQ.Interest_Dir,VQ.fnames(i).name], '', 2, 0);
    if(~exist([VQ.VQ_Dir_Name, VQ.fnames{i},'.mat'], 'file'))
        if(exist([VQ.Interest_Dir,VQ.fnames{i}, '.desc']))
            %         descriptor = load([VQ.Interest_Dir,VQ.fnames{i}]);
            
            feature = dlmread([VQ.Interest_Dir,VQ.fnames{i}, '.desc'], '', 3, 0);
            feature(:, end) = [];
            tmpdescp = feature(:,8:VQ.featLenth+7)'; %%97 for HOF
            
            if(strcmpi(VQ.Codebook_Type, 'generic'))
                L2D = slmetric_pw(tmpdescp, K_M_centers, 'eucdist');
                %                 L2D = L2_distance(tmpdescp, K_M_centers);
                [minD,tmpToken] = min(L2D');
            elseif(strcmpi(VQ.Codebook_Type, 'hkmeans'))
                [asgn]=HKmeansassign(K_M_centers,tmpdescp) ;
                levelWeight = VQ.K.^(fliplr(1: size(asgn, 1))-1);
                tmpToken = levelWeight*double(asgn-1);
            else
                fprintf('No such codebook for VQ!!\n');
            end;
            
            descriptor_vq = [feature(:, 2:4)'; tmpToken];
            
%             %% reshape the vector to patch structure image.
%             struct_Img_height=sum(descriptor_vq(1,:)==descriptor_vq(1, 1));
%             struct_Img=reshape(descriptor_vq(3,:),struct_Img_height,[]);
            
            %% save descriptor_vq variable to file....
            [pathstr, name, ext, versn] = fileparts(VQ.fnames{i});
            if(~exist([VQ.VQ_Dir_Name, pathstr],'dir'))
                mkdir([VQ.VQ_Dir_Name, pathstr]);
            end;
            save([VQ.VQ_Dir_Name, VQ.fnames{i},'.mat'], 'descriptor_vq');
        end;
    end;
end

total_time=toc;

fprintf('\nFinished running VQ process\n');
fprintf('Total number of images: %d, mean time per image: %f secs\n',nImages,total_time/nImages);




