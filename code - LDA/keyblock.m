function y = keyblock(img, row_up, row_down, col_left, col_right);
% DESCRIPTION:
%   get needed blocks of sample img specified by row and column.
% PARAMETERS:
%   img:
%       input sample img.
%   row_up:
%       deleted row ratio of sample img (up): 0<row<=1
%   row_down:
%       deleted row ratio of sample img (down): 0<row<=1
%   col_left:
%       deleted column ratio of sample img (left): 0<column<=1
%   col_right:
%       deleted column ratio of sample img (right): 0<column<=1
% RETURN:
%   y:
%       img of needed blocks of sample img.

% check parameters's validity
if (row_up<0 || row_up>1 || row_down<0 || row_down>1 || (row_up+row_down)>=1)
    error('Error: wrong row ratio.')
end
if (col_left<0 || col_left>1 || col_right<0 || col_right>1 || (col_left+col_right)>=1)
    error('Error: wrong column ratio.')
end

% image size
[M, N, K] = size(img);

% sub img origin
newy = round(row_up * M);
newx = round(col_left * N);
% sub img size
newH = round((1 - row_up - row_down)*M);
newW = round((1 - col_right - col_left)*N);

% clip img 
y = imcrop(img, [newx, newy, newW-1, newH-1]);
