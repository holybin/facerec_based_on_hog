function [eigvector, eigvalue] = TDPCA(A);
% description:
%   calculate 2D-PCA of input image set.
% parameters:
%   A = [A1,A2,...,AN]: 1 * N matrix, where each element(column) represents an image
% return:
%   eigvector: eigen vectors
%   eigvalue: eigen values

% image size
[m, n] = size(A{:,1});
% number of images
N = size(A, 2);
% mean value of images
sumval = double(zeros(m, n));
for i = 1:N
    sumval = sumval + double(A{:,i});
end
meanval = sumval / N;
% scatter matrix: n * n
sumGt = double(zeros(n, n));
for j = 1:N
    diff = double(A{:,j}) - meanval;
    sumGt = sumGt + (diff)' * (diff);
end
Gt = sumGt / N;
% eigen vectors & values
[eigvector,  eigvalue] = eig(Gt);
