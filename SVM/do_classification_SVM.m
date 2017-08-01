function do_classification_SVM(config_file)

%% By Xiangang Cheng, CeMNeT, NTU, SG
%% xiangang@pmail.ntu.edu.sg
%% 20/10/2009
EXPTYPE = 'svm';%

eval(config_file);

finalResults = [];


load([CLASSIFIER.dataDir, '_train.mat'], 'trData', 'trLabel');
load([CLASSIFIER.dataDir, '_validation.mat'], 'valData', 'valLabel');
load([CLASSIFIER.dataDir, '_test.mat'], 'teData', 'teLabel');
% 
tic;
curtrKernel = slmetric_pw(trData', trData', 'chisq');
total_time=toc;
fprintf('Computation time %f\n', total_time);
tic;
curvalKernel = slmetric_pw(trData', valData', 'chisq');
total_time=toc;
fprintf('Computation time %f\n', total_time);
tic;
curteKernel = slmetric_pw(trData', teData', 'chisq');
total_time=toc;
fprintf('Computation time %f\n', total_time);

% load('kthData.mat', 'curtrKernel', 'curvalKernel');
% save('kthData.mat', 'curtrKernel', 'curvalKernel', 'curteKernel');

Ac = mean(curtrKernel(:));

curtrKernel = curtrKernel/Ac;
curvalKernel = curvalKernel/Ac;
curteKernel = curteKernel/Ac;

%     curtrKernel = kernelMat(trLabel(:,1), trLabel(:,1));
%     curteKernel = kernelMat(trLabel(:,1), teLabel(:,1));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Training & Validation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
maxAcc = 0;
for i = 1:length(CLASSIFIER.C)
    parms.C= 2^CLASSIFIER.C(i);
    for j = 1:length(CLASSIFIER.gamma)
        parms.gamma = 2^CLASSIFIER.gamma(j);
        decision = [];
        
        nn = size(trLabel, 1);
        kk = size(valLabel, 1);
        %             mm = size(teLabel, 1);
        trKernel = [(1:nn);exp(-parms.gamma*curtrKernel)]';
        valKernel = [(1:kk);exp(-parms.gamma*curvalKernel)]';
        
        for cc = 1:CLASSIFIER.clsNum
            CLASSNUM = cc;
            
            TRNlabels = double((trLabel == CLASSNUM));
            TRNlabels(~TRNlabels) = -1;
            VALlabels = double((valLabel == CLASSNUM));
            VALlabels(~VALlabels) = -1;
            
            resultTrain = classifier_train(TRNlabels,trKernel, parms.C);
            dec_val = classifier_test(VALlabels,valKernel,resultTrain);
            
            decision = [decision, dec_val*VALlabels(1)];
        end;
        
        [tmp, predict] = max(decision');
        accuracy=100*mean(predict'==valLabel);
        fprintf('%d %.1f %6.2f\n',CLASSIFIER.C(i), CLASSIFIER.gamma(j), accuracy);
        
        if(accuracy>maxAcc)
            maxAcc = accuracy;
            bestGamma = CLASSIFIER.gamma(j);
            bestC = CLASSIFIER.C(i);
        end;
    end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Training & Testing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parms.gamma = 2^bestGamma;
parms.C= 2^bestC;
nn = size(trLabel, 1);
mm = size(teLabel, 1);
trKernel = [(1:nn);exp(-parms.gamma*curtrKernel)]';
teKernel = [(1:mm);exp(-parms.gamma*curteKernel)]';
decision = [];
for cc = 1:CLASSIFIER.clsNum
    CLASSNUM = cc;
    
    TRNlabels = double((trLabel(:,1) == CLASSNUM));
    TRNlabels(~TRNlabels) = -1;
    TSTlabels = double((teLabel(:,1) == CLASSNUM));
    TSTlabels(~TSTlabels) = -1;
    
    resultTrain = classifier_train(TRNlabels,trKernel, parms.C);
    dec_val = classifier_test(TSTlabels,teKernel,resultTrain);
    
    decision = [decision, dec_val*TSTlabels(1)];
end;

[tmp, predict] = max(decision');
accuracy=100*mean(predict'==teLabel);
fprintf('%d %.1f %6.2f\n',bestC, bestGamma, accuracy);

return;



%%
function resultTrain = classifier_train(train_label,kernelMatrix, cv_C)


% [cv_C, cv_G] = cross_Validation(train_label, train_data); 

resultTrain.model = svmtrain(train_label, kernelMatrix, ['-t 4 -m 500 -c ',num2str(cv_C)]);
% save(path_mat, 'resultTrain');
%%


function confidence = classifier_test(test_label,test_kernelMatrix,resultTrain)

[predict_label, accuracy, dec_values] = svmpredict(test_label, test_kernelMatrix, resultTrain.model);

confidence = dec_values;