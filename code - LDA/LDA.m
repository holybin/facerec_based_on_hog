function [eigvector, eigvalue] = LDA(A, classnum, num);
% description:
%   calculate LDA of input samples.
% parameters:
%   A = [A1;A2;...;AN]: N * 1 matrix, where each element(row) represents
%   a sample.
%   classnum: class number.
%   num: sample number of each class.
% return:
%   eigvector: eigen vectors
%   eigvalue: eigen values

% mean value of total samples
meanval = mean(A);
% mean value of the same class
for i = 1:classnum
    meanvalclass(i,:)=mean(A((i-1)*num+1:i*num,:));
end

% Sw: covariance matrix within classs
% pack;
Sw = 0;
for i = 1:classnum
    for j = 1:num
        diff = A((i-1)*num+j,:)-meanvalclass(i,:);
        Sw = Sw + (diff)'*(diff);
    end
end
% Sb: covariance matrix between classs
% pack;
Sb = 0;
for i = 1:classnum
    diff = meanvalclass(i,:)-meanval;
    Sb = Sb + num*(diff)'*(diff);
end

% % projection vector for Sb/Sw
% pinvSw = pinv(Sw);
% newspace = pinvSw * Sb;
% % eigenvectors & eigenvalues
% [eigvector, eigvalue] = eig(newspace);

[eigvector, eigvalue] = eig(Sb, Sw); % inv(Sw)*Sb
