function [newData, mu, sigma] = data_norm(oldData, mu, sigma)
%normalise the feature

if nargin < 3, 
    mu = mean(oldData);
    sigma = std(oldData);
end;

r = size(oldData, 1);

newData = oldData-ones(r,1)*mu;

newData = newData./(ones(r,1)*sigma);