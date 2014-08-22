function [newsamples basevector] = PCA(samples,num)
% DESCRIPTON:
%   PCA analysis.
% PARAMETERS:
%   samples:
%       input sample set, each row is a sample.
%   num:
%       control variable:
%       if 1>num>0, num is ratio of eigenvalues needed;
%       if num>=1, num is number of eigenvalues needed.
% RETURN:
%   newsamples:
%       output sample set after projection.
%   basevector:
%       needed eigen vectors.

[u v] = size(samples);
totalsamplemean = mean(samples);
for i = 1:u
    gensample(i,:) = samples(i,:)-totalsamplemean;
end
% scatter matrix
sigma = gensample*gensample';
% eigen vectors and values
[U V] = eig(sigma);
% sorting
d = diag(V);
[d1 index] = dsort(d);
if num>1
    for i = 1:num
        vector(:,i) = U(:,index(i));
        base(:,i) = d(index(i))^(-1/2)* gensample' * vector(:,i);
    end
else
    sumv = sum(d1);
    for i = 1:u
        if sum(d1(1:i))/sumv >= num
            l = i;
            break;
        end
    end
    for i = 1:l
        vector(:,i) = U(:,index(i));
        base(:,i) = d(index(i))^(-1/2)* gensample' * vector(:,i);
    end
end
% projection
newsamples = samples*base;
% base vectors
basevector = base;
