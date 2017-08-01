%%%%% Global configuration file %%%%%%

%% By Xiangang Cheng, CeMNeT, NTU, SG
%% xiangang@pmail.ntu.edu.sg
%% 17/10/2008
%%% Holds all settings used in all parts of the code, enabling the exact
%%% reproduction of the experiment at some future date.

%%% Single most important setting - the overall experiment type
%%% used by do_all.m


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% DIRECTORIES - please change if copying the code to a new location
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath([cd, '\common\']);

projectPath = 'W:\EXPERIMENT\KTH\';

% patchType = 'patchsize8';
%%% Directory holding the experiment 
% RUN_DIR = [projectPath,'experiments/' ];
% 
% %%% Directory holding all the source images
% IMAGE.dir = [projectPath,'data/' ];


%% Codebook directory - holds all VQ codebooks 
CODEBOOK_DIR = [projectPath, '\codebooks\' ];   
%% If codebook file folder not exist
if(~exist(CODEBOOK_DIR));
    mkdir(CODEBOOK_DIR);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% GLOBAL PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% subdirectory, file prefix and file extension of interest point files 
Global.Interest_Dir1 = [projectPath,'\KTHHOG\' ];
Global.Interest_Dir = [projectPath,'\KTHhof\' ];
% 
% if(~exist(Global.Interest_Dir,'dir'))
%     mkdir(Global.Interest_Dir);
% end;

ip_file_names = searchfiles(Global.Interest_Dir, '.desc');

% subfolder = dir(Global.Interest_Dir);
% ip_file_names = {};
% for i = 3 : length(subfolder)
%     if(subfolder(i).isdir)
%         dirFolder = dir([Global.Interest_Dir, subfolder(i).name, '\*.desc']);
%         for j = 1 : length(dirFolder)
%             [pathstr, name, ext, versn] = fileparts(dirFolder(j).name);
% %             A = imread([Global.Interest_Dir,subfolder(i).name,filesep,name, ext]);
%             ip_file_names = [ip_file_names; subfolder(i).name,filesep,name];
%         end;
%     end;
% end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% VECTOR QUANTIZATION SETTINGS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Type of descriptor to use
VQ.Codebook_Type                = 'generic';%'hkmeans';%%%'hkmeans';
VQ.Max_Feature_Size             =  1000000;
%% for generic k-means
if(strcmpi(VQ.Codebook_Type, 'generic'))
    VQ.Group = 1;
    % Number of entries in codebook
    VQ.Codebook_Size                 = 4000;
    % Number of k-means iterations to use
    VQ.Max_Iterations                = 100;
    % Verbosity level of k-means
    VQ.Verbosity                     = 0;
    VQ.infor = num2str(VQ.Codebook_Size);
    VQ.Codebook_Name = ['ACTION_STIP_HOF_4000.mat'];
end;


% %% for Hierachical-Kmeans
% if(strcmpi(VQ.Codebook_Type, 'hkmeans'))
%     VQ.Group = 1;
%     VQ.K = 4; 
%     VQ.depth = 6; 
%     VQ.Codebook_Size = VQ.K.^VQ.depth;
%     VQ.infor = [num2str(VQ.K),'_', num2str(VQ.depth)] ;
%     VQ.Codebook_Name = ['scene_SIFT_HKmeans_16_',VQ.infor, '_',num2str(VQ.Group),'.mat'];
% end;
% %%

% Global.VQ_Dir_Name = [projectPath,'\descriptor_1_dense_',VQ.infor, '_',num2str(VQ.Group),'\' ];

Global.VQ_Dir_Name = [projectPath,'\descriptors_',num2str(VQ.Codebook_Size),'\descriptor_HOF\' ];

if(~exist(Global.VQ_Dir_Name,'dir'))
    mkdir(Global.VQ_Dir_Name);
end;


