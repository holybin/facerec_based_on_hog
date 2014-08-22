% proc_test.m
% This file will process testing set to get feature description

clearvars -except HOG_para;
close all;

%% STEP1 - load testing samples
disp(' - LOAD TESTING SET: test.mat')
load('test.mat');
[classnum, testnum] = size(test);

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
testGHOG = cell(1,testnum*classnum);  % GLOBAL HOG
testLHOG = []; % LOCAL HOG
for i = 1:classnum
    for j = 1:testnum
        % get sub-img of proper size for HOG calculation
        img = test(i,j).image;
        globalImg = HOGimg(img, cellpw, cellph, nblockw, nblockh);
        % global HOG feature
        globalHog = HOG(double(globalImg), cellpw, cellph, nblockw, nblockh,...
            nthet, overlap, isglobalinterpolate, issigned, normmethod);
        [hG, wG] = size(globalHog);
        testGHOG{1,(i-1)*testnum+j} = globalHog;  % cell: 1*samplenum

        % get sub-img of key blocks for HOG calculation
        localImg = keyblock(img, 0.1, 0.2, 0.1, 0.1);
        localImg = HOGimg(localImg, cellpw, cellph, nblockw, nblockh);
        % local HOG feature
        localHog = HOG(double(localImg), cellpw, cellph, nblockw, nblockh,...
            nthet, overlap, isglobalinterpolate, issigned, normmethod);
        [hL, wL] = size(localHog);
        testLHOG((i-1)*testnum+j,:) = reshape(localHog,1,hL*wL);
    end
end
% save variables
save('testGHOG.mat', 'testGHOG');
save('testLHOG.mat', 'testLHOG');
clearvars -except classnum testnum;

%% STEP3.1 - global feature for testing set: 2D-PCA+LDA
disp(' - GLOBAL FEATURE: 2D-PCA + LDA')
load('testGHOG.mat');
load('basevectorG.mat');
load('pvectorG.mat');
% 2D-PCA projection
for i = 1:testnum*classnum
    % resize
    tmp = testGHOG{1,i} * basevectorG;
    [m, n] = size(tmp);
    testGTDPCA(i,:) = reshape(tmp, 1, m*n);
end

% LDA projection
testGFea = testGTDPCA * pvectorG;

% save variables
save('testGFea.mat', 'testGFea');
clearvars -except classnum testnum basevectorL pvectorL;

%% STEP3.2 - local feature for testing set: PCA+LDA
disp(' - LOCAL FEATURE: PCA + LDA')
load('testLHOG.mat');
load('basevectorL.mat');
load('pvectorL.mat');
% PCA projection
testLPCA = testLHOG * basevectorL;

% LDA projection
testLFea = testLPCA * pvectorL;

% save variables
save('testLFea.mat', 'testLFea');
clearvars -except classnum testnum;

%% STEP4 - feature fusion
disp(' - FEATURE FUSION ')
load('testGFea.mat');
load('testLFea.mat');
% global: m*n, local: p*q, final: max(m,p)*(n+q)
for i = 1:testnum*classnum
    testFeature(i,:) = [testGFea(i,:), testLFea(i,:)];
%     testFeature(i,:) = testGFea(i,:);
end

% save variables
save('testFeature.mat', 'testFeature');
