% main.m
clc;clear all;close all;

%%% choose dataset %%%
% 1 - ORL
% 2 - Yale
% 3 - FERET
% 4 - MIT-CBCL
% 5 - Caltech
% 6 - PIE
% 7 - UMIST
% 8 - YaleB
% 9 - grimace
% 10 - jaffe
% 11 - MUCT

database = 1;

%%% choose dataset %%%

% load dataset
disp('Step1: load image dataset.')
load_data;

% HOG parameters
cellpw = 8;     % block width
cellph = 8;     % block height
nblockw = 2;    % width cell number
nblockh = 2;    % height cell number
nthet = 9;      % number of bins per cell
overlap = 0.5;  % overlap proportion of two neighboring block
isglobalinterpolate = 'localinterpolate';   % trilinear interpolation method
issigned = 'unsigned';  % HOG angle: unsigned - [0,pi], signed - [0,2*pi]
normmethod = 'l2hys';   % method of normalization in a block
% passed HOG parameters
global HOG_para;
HOG_para = struct('numercial_para', [cellpw,cellph,nblockw,nblockh,nthet,overlap],...
                  'isglobalinterpolate', isglobalinterpolate,...
                  'issigned', issigned, 'normmethod', normmethod); 
% pause;

% process training samples
disp('Step2: process training set.')
proc_train;

% process testing samples
disp('Step3: process testing set.')
proc_test;

% random forest classification
disp('Step4: random forest classification.')
rf_classify;

% remove intermediate files
% delete *.mat;
% delete *.txt;

%   cforest.mat: forest parameters structure
%   cforest.txt: random forest file

%   basevectorG.mat: 2DPCA base vectors for GLOBAL HOG-feature projection
%   pvectorG.mat: LDA base vectors for GLOBAL HOG-feature projection
%   basevectorL.mat: PCA base vectors for LOCAL HOG-feature projection
%   pvectorL.mat: LDA base vectors for LOCAL HOG-feature projection

%   test.mat: testing data set
%   testLabel.mat: class label of testing data set
%   testGHOG.mat: global HOG feature of testing data set
%   testLHOG.mat: local HOG feature of testing data set
%   testGFea.mat: global feature description of testing data set
%   testLFea.mat: local feature description of testing data set
%   testFeature.mat: final feature description of testing data set

%   train.mat: training data set
%   trainLabel.mat: class label of training data set
%   trainGHOG.mat: global HOG feature of training data set
%   trainLHOG.mat: local HOG feature of training data set
%   trainGFea.mat: global feature description of training data set
%   trainLFea.mat: local feature description of training data set
%   trainFeature.mat: final feature description of training data set
