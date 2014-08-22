% load_data.m
% Load training set and testing set from image files

clearvars -except database;
close all;

%% ORL database: 40 class * 10 sample
if database == 1
    disp(' - USE ORL database')
    path = '..\ORL\s';
    classnum = 40;      % class number
    totalnum = 10;      % sample number per class
    trainnum = 7;       % train sample number per class
    testnum = (totalnum-trainnum);   % test sample number per class
    % load samples
    for i = 1:classnum
        class_dir = [path, num2str(i)];
        img_dir = dir(fullfile(class_dir,'*.bmp'));
        img_names = {img_dir.name};
        if size(img_names,2)<1
            continue;
        end
        % random selection
        index = randperm(totalnum);
        % training samples
        for j = 1:trainnum
            picname = fullfile(class_dir, char(img_names{index(j)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            train(i,j).image = I;
            trainLabel((i-1)*trainnum+j,1) = i;
        end
        % testing samples
        for k = 1:testnum
            picname = fullfile(class_dir, char(img_names{index(k+trainnum)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            test(i,k).image = I;
            testLabel((i-1)*testnum+k,1) = i;
        end
    end

%% Yale database
elseif database == 2
    disp(' - USE Yale database')
    path = '..\Yale';
    classnum = 15;      % class number
    totalnum = 11;      % sample number per class
    trainnum = 8;       % train sample number per class
    testnum = (totalnum-trainnum);   % test sample number per class
    % load samples
    for i = 1:classnum
        class_dir = [path, '\', num2str(i)];
        img_dir = dir(fullfile(class_dir,'*.bmp'));
        img_names = {img_dir.name};
        if size(img_names,2)<1
            continue;
        end
        % random selection
        index = randperm(totalnum);
        % training samples
        for j = 1:trainnum
            picname = fullfile(class_dir, char(img_names{index(j)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            train(i,j).image = I;
            trainLabel((i-1)*trainnum+j,1) = i;
        end
        % testing samples
        for k = 1:testnum
            picname = fullfile(class_dir, char(img_names{index(k+trainnum)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            test(i,k).image = I;
            testLabel((i-1)*testnum+k,1) = i;
        end
    end

%% FERET database 
elseif database == 3
    disp(' - USE FERET database')
    path = '..\FERET\FERET';
    classnum = 194;      % class number
    totalnum = 7;      % sample number per class
    trainnum = 4;       % train sample number per class
    testnum = (totalnum-trainnum);   % test sample number per class
    % load samples
    for i = 1:classnum
        class_dir = sprintf('%s-%.3d',path,i);
        img_dir = dir(fullfile(class_dir,'*.bmp'));
        img_names = {img_dir.name};
        if size(img_names,2)<1
            continue;
        end
        % random selection
        index = randperm(totalnum);
        % training samples
        for j = 1:trainnum
            picname = fullfile(class_dir, char(img_names{index(j)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            train(i,j).image = I;
            trainLabel((i-1)*trainnum+j,1) = i;
        end
        % testing samples
        for k = 1:testnum
            picname = fullfile(class_dir, char(img_names{index(k+trainnum)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            test(i,k).image = I;
            testLabel((i-1)*testnum+k,1) = i;
        end
    end
    
%% MIT-CBCL database
elseif database == 4
    disp(' - USE MIT-CBCL database')
    path = '..\MIT-CBCL_cropped_80_80';
    classnum = 10;      % class number
    totalnum = 200;      % sample number per class: NOT ALL USED!
    % random select training/testing samples
    trainnum = 10;       % train sample number per class
    testnum = 190;       % test sample number per class: USER DEFINED
    % load samples
    for i = 1:classnum
        class_dir = [path, '\', num2str(i)];
        img_dir = dir(fullfile(class_dir,'*.bmp'));
        img_names = {img_dir.name};
        if size(img_names,2)<1
            continue;
        end
        % random selection
        index = randperm(totalnum);
        % training samples
        for j = 1:trainnum
            picname = fullfile(class_dir, char(img_names{index(j)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            train(i,j).image = I;
            trainLabel((i-1)*trainnum+j,1) = i;
        end
        % testing samples
        for k = 1:testnum
            picname = fullfile(class_dir, char(img_names{index(k+trainnum)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            test(i,k).image = I;
            testLabel((i-1)*testnum+k,1) = i;
        end
    end
%% Caltech database
elseif database == 5
    disp(' - USE Caltech database')
    path = '..\Caltech_cropped_80_100';
    classnum = 19;      % class number
    totalnum = 15;      % sample number per class
    % random select training/testing samples
    trainnum = 10;       % train sample number per class
    testnum = totalnum-trainnum;       % test sample number per class
    % load samples
    for i = 1:classnum
        class_dir = [path, '\', num2str(i)];
        img_dir = dir(fullfile(class_dir,'*.bmp'));
        img_names = {img_dir.name};
        if size(img_names,2)<1
            continue;
        end
        % random selection
        index = randperm(totalnum);
        % training samples
        for j = 1:trainnum
            picname = fullfile(class_dir, char(img_names{index(j)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            train(i,j).image = I;
            trainLabel((i-1)*trainnum+j,1) = i;
        end
        % testing samples
        for k = 1:testnum
            picname = fullfile(class_dir, char(img_names{index(k+trainnum)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            test(i,k).image = I;
            testLabel((i-1)*testnum+k,1) = i;
        end
    end
%% PIE database
elseif database == 6
    disp(' - USE PIE database')
    path = '..\PIE_cropped_64_64';
    classnum = 68;      % class number
    totalnum = 49;      % sample number per class
    % random select training/testing samples
    trainnum = 10;       % train sample number per class
    testnum = totalnum-trainnum;       % test sample number per class
    % load samples
    for i = 1:classnum
        class_dir = [path, '\', num2str(i)];
        img_dir = dir(fullfile(class_dir,'*.bmp'));
        img_names = {img_dir.name};
        if size(img_names,2)<1
            continue;
        end
        % random selection
        index = randperm(totalnum);
        % training samples
        for j = 1:trainnum
            picname = fullfile(class_dir, char(img_names{index(j)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            train(i,j).image = I;
            trainLabel((i-1)*trainnum+j,1) = i;
        end
        % testing samples
        for k = 1:testnum
            picname = fullfile(class_dir, char(img_names{index(k+trainnum)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            test(i,k).image = I;
            testLabel((i-1)*testnum+k,1) = i;
        end
    end
%% UMIST database
elseif database == 7
    disp(' - USE UMIST database')
    path = '..\UMIST_cropped_92_112';
    classnum = 20;      % class number
    totalnum = 7;      % sample number per class
    % random select training/testing samples
    trainnum = 4;       % train sample number per class
    testnum = totalnum-trainnum;       % test sample number per class
    % load samples
    for i = 1:classnum
        class_dir = [path, '\', num2str(i)];
        img_dir = dir(fullfile(class_dir,'*.bmp'));
        img_names = {img_dir.name};
        if size(img_names,2)<1
            continue;
        end
        % random selection
        index = randperm(totalnum);
        % training samples
        for j = 1:trainnum
            picname = fullfile(class_dir, char(img_names{index(j)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            train(i,j).image = I;
            trainLabel((i-1)*trainnum+j,1) = i;
        end
        % testing samples
        for k = 1:testnum
            picname = fullfile(class_dir, char(img_names{index(k+trainnum)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            test(i,k).image = I;
            testLabel((i-1)*testnum+k,1) = i;
        end
    end
%% YaleB database
elseif database == 8
    disp(' - USE YaleB database')
    path = '..\YaleB_cropped_84_96';
    classnum = 38;      % class number
    totalnum = 59;      % sample number per class: AT LEAST
    % random select training/testing samples
    trainnum = 10;       % train sample number per class
    testnum = 49;       % test sample number per class: USER DEFINED
    % load samples
    for i = 1:classnum
        class_dir = sprintf('%s\\yaleB%.2d',path, i);
        img_dir = dir(fullfile(class_dir,'*.bmp'));
        img_names = {img_dir.name};
        if size(img_names,2)<1
            continue;
        end
        % random selection
        index = randperm(totalnum);
        % training samples
        for j = 1:trainnum
            picname = fullfile(class_dir, char(img_names{index(j)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            train(i,j).image = I;
            trainLabel((i-1)*trainnum+j,1) = i;
        end
        % testing samples
        for k = 1:testnum
            picname = fullfile(class_dir, char(img_names{index(k+trainnum)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            test(i,k).image = I;
            testLabel((i-1)*testnum+k,1) = i;
        end
    end
%% grimace database
elseif database == 9
    disp(' - USE grimace database')
    path = '..\grimace_cropped_80_80';
    classnum = 18;      % class number
    totalnum = 20;      % sample number per class
    % random select training/testing samples
    trainnum = 10;       % train sample number per class
    testnum = 10;       % test sample number per class: USER DEFINED
    % load samples
    for i = 1:classnum
        class_dir = sprintf('%s\\%d',path, i);
        img_dir = dir(fullfile(class_dir,'*.bmp'));
        img_names = {img_dir.name};
        if size(img_names,2)<1
            continue;
        end
        % random selection
        index = randperm(totalnum);
        % training samples
        for j = 1:trainnum
            picname = fullfile(class_dir, char(img_names{index(j)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            train(i,j).image = I;
            trainLabel((i-1)*trainnum+j,1) = i;
        end
        % testing samples
        for k = 1:testnum
            picname = fullfile(class_dir, char(img_names{index(k+trainnum)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            test(i,k).image = I;
            testLabel((i-1)*testnum+k,1) = i;
        end
    end
%% jaffe database
elseif database == 10
    disp(' - USE jaffe database')
    path = '..\jaffe_cropped_80_80';
    classnum = 10;      % class number
    totalnum = 20;      % sample number per class
    % random select training/testing samples
    trainnum = 10;       % train sample number per class
    testnum = 10;       % test sample number per class: USER DEFINED
    % load samples
    for i = 1:classnum
        class_dir = sprintf('%s\\%d',path, i);
        img_dir = dir(fullfile(class_dir,'*.bmp'));
        img_names = {img_dir.name};
        if size(img_names,2)<1
            continue;
        end
        % random selection
        index = randperm(totalnum);
        % training samples
        for j = 1:trainnum
            picname = fullfile(class_dir, char(img_names{index(j)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            train(i,j).image = I;
            trainLabel((i-1)*trainnum+j,1) = i;
        end
        % testing samples
        for k = 1:testnum
            picname = fullfile(class_dir, char(img_names{index(k+trainnum)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            test(i,k).image = I;
            testLabel((i-1)*testnum+k,1) = i;
        end
    end
%% MUCT database
elseif database == 11
    disp(' - USE MUCT database')
    path = '..\MUCT_cropped_80_80';
    classnum = 199;      % class number
    totalnum = 15;      % sample number per class
    % random select training/testing samples
    trainnum = 10;       % train sample number per class
    testnum = 5;       % test sample number per class: USER DEFINED
    % load samples
    for i = 1:classnum
        class_dir = sprintf('%s\\%d',path, i);
        img_dir = dir(fullfile(class_dir,'*.bmp'));
        img_names = {img_dir.name};
        if size(img_names,2)<1
            continue;
        end
        % random selection
        index = randperm(totalnum);
        % training samples
        for j = 1:trainnum
            picname = fullfile(class_dir, char(img_names{index(j)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            train(i,j).image = I;
            trainLabel((i-1)*trainnum+j,1) = i;
        end
        % testing samples
        for k = 1:testnum
            picname = fullfile(class_dir, char(img_names{index(k+trainnum)}));
            I = imread(picname);
            [m,n,p] = size(I);
            if p == 3
                I = rgb2gray(I);
            end
            I = histeq(I);
            test(i,k).image = I;
            testLabel((i-1)*testnum+k,1) = i;
        end
    end     
end

% save dataset as .mat file
save('train.mat', 'train');
save('test.mat', 'test');
save('trainLabel.mat', 'trainLabel');
save('testLabel.mat', 'testLabel');
