% rf_classify.m
% Random forest classification.

clear all;close all;

% reload data
load('trainFeature.mat');
load('trainLabel.mat');
load('testFeature.mat');
load('testLabel.mat');

% disp(' - random forest training')
% disp(' - random forest testing')
nclass = length(unique(trainLabel));
cat = ones(1,size(trainFeature,2));
classwt = ones(1,nclass);
param = [100  3   nclass   0   1 ...
         1   0   0   0   0 ...
         0   2   0   0   123];
% classification
out = RFClass(param, trainFeature, trainLabel, cat, classwt, testFeature, testLabel);
printRF(out);
save('cforest.mat', 'out');

% % Plot Variable Importance  
% figure;
% bar(out.errimp, 0.1);
% title('Variable Importance');
% xlabel('');
% ylabel('');
