%%%%% Global configuration file %%%%%%

%% By Xiangang Cheng, CeMNeT, NTU, SG
%% xiangang@pmail.ntu.edu.sg
%% 23/MAR/2010
%%% Holds all settings used in all parts of the code, enabling the exact
%%% reproduction of the experiment at some future date.

%%% Single most important setting - the overall experiment type
%%% used by do_all.m
%%% Here I use the switch function to set the certaion part of the
%%% project.Since different parts are independent.
%%%



DATAPATH = 'E:\xiangang\EXPERIMENT\webvideo\'; %This is the folder to save all the data of the whole project
if(~exist(DATAPATH, 'dir'));
    mkdir(DATAPATH);
end;


switch lower(EXPTYPE)
    case 'global'
        addpath([cd, '\common\']);
        addpath([cd, '\stipfeat']);
        addpath([cd, '\stbow\']);
        addpath([cd, '\SVM\']);
        addpath([cd, '\clustering\']);  
    case 'stipfeat'
        patchType = 'HOG';
        VIDEO.dir = 'E:\xiangang\Database\webvideo3\';
        extractor_path = [cd, '\stipfeat\'];    
        Feat.dir = [DATAPATH, '\webvideo',patchType,'\'];
        if(~exist(Feat.dir,'dir'))
            mkdir(Feat.dir);
        end;
        
        curExtractor = 'stip.exe ';
        detector = '-stip ';
        descriptor = '-dscr hog ';
        option = ' -vis no -thresh 1e-008 ';
    
        extractor = [extractor_path, curExtractor];
%         VIDEO.dir = 'Y:\dataset\KTH\';
%         extractor_path = [cd, '\stipfeat\'];    
%         Feat.dir = [DATAPATH, '\KTH',patchType,'\'];
%         if(~exist(Feat.dir,'dir'))
%             mkdir(Feat.dir);
%         end;
%         
%         curExtractor = 'stip.exe ';
%         detector = '-stip ';
%         descriptor = '-dscr hof ';
%         option = ' -vis no -thresh 0 ';
%     
%         extractor = [extractor_path, curExtractor];
    case 'codebook'
        patchType = 'HOF0';
        VQ.Interest_Dir = 'Y:\EXPERIMENT\HOF_thresh_0\';%[DATAPATH,'\KTH', patchType,'\' ];
        VQ.featLenth = 90; %% set the length of feature vector here. for Hog - 72, HOF -- 90
        VQ.fnames = searchfiles(VQ.Interest_Dir, '.desc');
        
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
            VQ.Codebook_Name = ['ACTION_STIP_',patchType(1:3),'_4000_old.mat'];
        end;
        VQ.CODEBOOK_DIR = [DATAPATH,'\codebooks'];
        if(~exist(VQ.CODEBOOK_DIR, 'dir'))
            mkdir(VQ.CODEBOOK_DIR);
        end;
        
        VQ.VQ_Dir_Name = [DATAPATH,'\descriptors_',num2str(VQ.Codebook_Size),'\descriptor_',patchType,'\' ];
        
        if(~exist(VQ.VQ_Dir_Name,'dir'))
            mkdir(VQ.VQ_Dir_Name);
        end;
    
    case 'stbow'
%         addpath([cd, '\stbow\']);
    
        load('KTHparameter.mat');
        patchType = 'HOF0';

        STBOW.vqSize = 4000;     
        STBOW.height = 120;
        STBOW.width = 160;
        
        STBOW.lvlType = 1; %0-- no level, 1--level 3x1x1
        
        STBOW.VQ_Dir = [DATAPATH,'\descriptors_',num2str(STBOW.vqSize),'\descriptor_', patchType, filesep ];
        STBOW.type = '.mat';
%         STBOW.fnames = searchfiles(STBOW.VQ_Dir, STBOW.type);
        STBOW.fnames = parameter.filename;
        STBOW.subdir = parameter.dir;
        STBOW.frameIdx = parameter.frameIdx;
        
        STBOW.feat_Dir = [DATAPATH,'\stbow_',num2str(STBOW.vqSize), filesep, 'stbow_', patchType,filesep];
        if(~exist(STBOW.feat_Dir, 'dir'))
            mkdir(STBOW.feat_Dir);
        end;
                
    case 'predata'
%         addpath([cd, '\stbow\']);
    
        load('KTHparameter.mat');
        patchType = 'HOF0';

        STBOW.vqSize = 4000;     
        STBOW.height = 120;
        STBOW.width = 160;
        
%         STBOW.VQ_Dir = [DATAPATH,'\descriptors_',num2str(STBOW.vqSize),'\descriptor_', patchType, filesep ];
%         STBOW.type = '.mat';

%         STBOW.fnames = searchfiles(STBOW.VQ_Dir, STBOW.type);
        STBOW.fnames = parameter.filename;
        STBOW.subdir = parameter.dir;
        STBOW.frameIdx = parameter.frameIdx;
        
        STBOW.feat_Dir = [DATAPATH,'\stbow_',num2str(STBOW.vqSize), filesep, 'stbow_', patchType, filesep];
        if(~exist(STBOW.feat_Dir, 'dir'))
            mkdir(STBOW.feat_Dir);
        end;
        
        STBOW.cFileName = [DATAPATH, '\cSparsefeat_',num2str(STBOW.vqSize), filesep, patchType];
        if(~exist([DATAPATH,'\cSparsefeat_',num2str(STBOW.vqSize), filesep], 'dir'))
            mkdir([DATAPATH,'\cSparsefeat_',num2str(STBOW.vqSize), filesep]);
        end;
    case 'svm'
                   
        patchType = 'HOF0';
        
        CLASSIFIER.clsNum = 6;
        
        CLASSIFIER.vqSize = 4000;
        CLASSIFIER.dataDir = [DATAPATH, '\cSparsefeat_',num2str(CLASSIFIER.vqSize), filesep, patchType];
        
%         CLASSIFIER.labelDir = [DATAPATH,'\dataIdx1\'];
%         CLASSIFIER.labelFile = ['label_g',num2str(gNum), '.mat'];
        
        
%         CLASSIFIER.knlFile = [DATAPATH, 'newCoKnlMat\', typeI, '.mat'];%['D:\xiangang\code_spm1\', typeI,'.mat'];%['X:\spatialPyramidCode\spatial_pyramid_code\', typeI,'.mat'];%[DATAPATH,'\coKnlMat_',num2str(CLASSIFIER.vqSize),'_org', filesep, typeI, '_v1'];%;%[DATAPATH,'\coKnlMat_',num2str(CLASSIFIER.vqSize), filesep, 'scene_coknlMat_', patchType,'.mat'];%[DATAPATH,'\coKnlMat_',num2str(CLASSIFIER.vqSize), filesep, 'scene_msfMat_Li.mat'];%;%
        CLASSIFIER.C = -10:10;
        CLASSIFIER.gamma = -10:10;
%         CLASSIFIER.TYPEreg = 1;
        
%         CLASSIFIER.resultsDir = [DATAPATH, '\results_CLASSIFIER_bow_48\'];
%         if(~exist(CLASSIFIER.resultsDir, 'dir'))
%             mkdir(CLASSIFIER.resultsDir);
%         end
%         
%         %         CLASSIFIER.resultsFile = 'results.txt';
%         CLASSIFIER.resultsFile = ['results11_',patchType,'_g', num2str(gNum),'.txt'];
    otherwise
        error('Please select the right EXP part. Unknown type %s', EXPTYPE);
end;


