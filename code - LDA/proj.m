function [peigvector, peigvalue] = proj(eigvector, eigvalue, num);
% description:
%   calculate needed vectors & values for projection.
% parameters:
%   eigvector: eigen vectors
%   eigvalue: eigen values
%   num: if 1>num>0, num is ratio of eigenvalues needed;
%        if num>=1, num is number of eigenvalues needed.
% return:
%   peigvector: needed eigenvectors
%   peigvalue: needed eigenvalues

totalnum = size(eigvector, 2);
% diagonal elements
deigvalue = diag(eigvalue);
% sort in descending order
[T, index] = dsort(deigvalue);
for i = 1:totalnum
    sorteigvalue(i) = deigvalue(index(i));   % row vector
    sorteigvector(:,i) = eigvector(:, index(i)); % each column is en egenvector
    % normalize eigen vectors
    % sorteigvector(:,i) = sorteigvector(:,i)/norm(sorteigvector(:,i));
end;

% get needed vectors & values
if num >= 1     %num>=1: specify needed number of eigenvectors
    % exceed max number of eigenvectors
    if (num > totalnum)
        fprintf(1,'Warning: num is %d; only %d exist.\n',num,totalnum);
        num = totalnum;
    end
else    %0<num<1: use ratio of eigenvalues
    evalsum = sum(sorteigvalue);
    evalsum_needed = 0;
    num_needed = 0;
    while (evalsum_needed / evalsum < num)
        num_needed = num_needed + 1;
        evalsum_needed = evalsum_needed + sorteigvalue(num_needed);
    end
    num = num_needed;
end

peigvalue = sorteigvalue(1:num);
peigvector = sorteigvector(:,1:num);
