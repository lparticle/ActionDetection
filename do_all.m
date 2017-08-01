function do_all

clc
clear all

config_file = 'config_file_action';
EXPTYPE = 'global';

eval(config_file);

%%% Extract STIP feature.
do_extract_STIP(config_file);

% eval(config_file);
%%%Generate codebooks for STIP feature
% do_form_codebook_stip(config_file);

%%% Assign the STIP feature with a visual word
% do_vq_stip(config_file);
% 
% %%% Form the histogram at certain level
% do_stbow(config_file);
% 
% %%% Prepare training & testing data
% do_predata(config_file);
% 
% %%% Do SVM for classification
% do_classification_SVM(config_file)
