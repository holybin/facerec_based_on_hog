% proc_train.m
% This file will process training set to get feature description

clearvars -except HOG_para;
close all;

%% STEP1 - load training samples
disp(' - LOAD TRAINING SET: train.mat')
load('train.mat');
[classnum, trainnum] = size(train);

%% STEP2 - HOG feature extraction
disp(' - HOG FEATURE EXTRACTION')

% HOG parameters
global HOG_para;
cellpw = HOG_para.numercial_para(1);     % block width
cellph = HOG_para.numercial_para(2);     % block height
nblockw = HOG_para.numercial_para(3);    % width cell number
nblockh = HOG_para.numercial_para(4);    % height cell number
nthet = HOG_para.numercial_para(5);      % number of bins per cell
overlap = HOG_para.numercial_para(6);  % overlap proportion of two neighboring block
isglobalinterpolate = HOG_para.isglobalinterpolate;   % trilinear interpolation method
issigned = HOG_para.issigned;  % HOG angle: unsigned - [0,pi], signed - [0,2*pi]
normmethod = HOG_para.normmethod;   % method of normalization in a block

% HOG calculation
trainGHOG = cell(1,trainnum*classnum);  % GLOBAL HOG
trainLHOG = []; % LOCAL HOG
for i = 1:classnum
    for j = 1:trainnum
        % get sub-img of proper size for HOG calculation
        img = train(i,j).image;
        globalImg = HOGimg(img, cellpw, cellph, nblockw, nblockh);
        % global HOG feature
        globalHog = HOG(double(globalImg), cellpw, cellph, nblockw, nblockh,...
            nthet, overlap, isglobalinterpolate, issigned, normmethod);
        [hG, wG] = size(globalHog);
        trainGHOG{1,(i-1)*trainnum+j} = globalHog;  % cell: 1*samplenum

        % get sub-img of key blocks for HOG calculation
        localImg = keyblock(img, 0.1, 0.2, 0.1, 0.1);
        localImg = HOGimg(localImg, cellpw, cellph, nblockw, nblockh);
        % local HOG feature
        localHog = HOG(double(localImg), cellpw, cellph, nblockw, nblockh,...
            nthet, overlap, isglobalinterpolate, issigned, normmethod);
        [hL, wL] = size(localHog);
        trainLHOG((i-1)*trainnum+j,:) = reshape(localHog,1,hL*wL);
        
%         figure;imshow(globalImg);
%         figure;imshow(localImg);
    end
end
% save variables
save('trainGHOG.mat', 'trainGHOG');
save('trainLHOG.mat', 'trainLHOG');
clearvars -except classnum trainnum;

%% STEP3.1 - global feature for training set: 2D-PCA+LDA
disp(' - GLOBAL FEATURE: 2D-PCA + LDA')
load('trainGHOG.mat');
% 2D-PCA
[eigvector, eigvalue] = TDPCA(trainGHOG);
[basevectorG, pvalue] = proj(eigvector, eigvalue, 0.9);
% projection
for i = 1:trainnum*classnum
    % resize
    tmp = trainGHOG{1,i} * basevectorG;
    [m, n] = size(tmp);
    trainGTDPCA(i,:) = reshape(tmp, 1, m*n);
end

% LDA
[eigvectorG, eigvalueG] = LDA(trainGTDPCA, classnum, trainnum);
[pvectorG, pvalueG] = proj(eigvectorG, eigvalueG, 0.99);
% projection
trainGFea = trainGTDPCA * pvectorG;

% save variables
save('trainGFea.mat', 'trainGFea');
save('basevectorG.mat', 'basevectorG');
save('pvectorG.mat', 'pvectorG');
clearvars -except classnum trainnum;

%% STEP3.2 - local feature for training set: PCA+LDA
disp(' - LOCAL FEATURE: PCA + LDA')
load('trainLHOG.mat');
% PCA
[trainLPCA basevectorL] = myPCA(trainLHOG, 0.9);

% LDA
[eigvectorL, eigvalueL] = LDA(trainLPCA, classnum, trainnum);
[pvectorL, pvalueL] = proj(eigvectorL, eigvalueL, 0.99);
% projection
trainLFea = trainLPCA * pvectorL;

% save variables
save('trainLFea.mat', 'trainLFea');
save('basevectorL.mat', 'basevectorL');
save('pvectorL.mat', 'pvectorL');
clearvars -except classnum trainnum;

%% STEP4 - feature fusion
disp(' - FEATURE FUSION ')
load('trainGFea.mat');
load('trainLFea.mat');
% global: m*n, local: p*q, final: max(m,p)*(n+q)
for i = 1:trainnum*classnum
    trainFeature(i,:) = [trainGFea(i,:), trainLFea(i,:)];
%     trainFeature(i,:) = trainGFea(i,:);
end

% save variables
save('trainFeature.mat', 'trainFeature');
