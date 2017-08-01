function [cv_C, cv_G] = cross_Validation(train_label, train_data ) 
%%%%%%%%%%%

N_FOLDS =  5;
N_TOP   =  inf; 
GAMMA   =  -6:6;
C       =  -10:10;

[m, n] = size(train_data);
center_g= 1.0/n;

[samples] = v_fold(N_FOLDS, train_label);

score = [];

for j = GAMMA
    gg = 2^(j*0.5)*center_g;
    
    for i = C;
        cc = 2^(i*0.5);
        
        eer = zeros(N_FOLDS, 1);

        for vv=1:N_FOLDS

            test_label_idx = train_label(samples{vv}.test_idx,1);
            test_data_idx  = train_data(samples{vv}.test_idx,:);   %the index of 0.2 part
            train_label_idx = train_label(samples{vv}.train_idx,1);
            train_data_idx = train_data(samples{vv}.train_idx,:); %the index of 0.8 part
            
            cls = svmtrain(train_label_idx, train_data_idx, ['-c ',num2str(cc),' -g ', num2str(gg)]);
            [predict_label, accuracy, dec_values] = svmpredict(test_label_idx, test_data_idx, cls);
            X = [dec_values, test_label_idx];
            [ P, OP, A, T ] = roc_Cal ( X );

            eer(vv) = OP;

            fprintf('EER:  %f    AUC:  %f\n', OP, A);
        end;
        
        score = [score; cc, gg, mean(eer)];
        fprintf('C: %f --g  %f --EER:  %f\n',cc,gg,mean(eer));
    end;
end;

[fMax,nIndex] =  max(score(:,3));

cv_C = score(nIndex,1);
cv_G = score(nIndex,2);

fprintf('Final Choice: C: %f --g  %f --EER:  %f\n',cv_C,cv_G,fMax);

return;



function [samples] = v_fold(v, train_label)

n = length(train_label);

pp = randperm(n);
runs = floor(n/v);
folds = {};

for j=1:v-1
    folds{j} = pp(((j-1)*runs +1):j*runs);
end;
folds{v} = pp(j*runs+1:end);

samples = {};
for i=1:v
    
    vidx = folds{i};
    tidx = setdiff(pp, vidx);
    
    samples{i}.test_idx  =  vidx; %0.2 part
    samples{i}.train_idx =  tidx; %0.8 part
    
end;

return;