function y = HOGimg(img, cellpw, cellph, nblockw, nblockh);
% DESCRIPTION:
%   get proper sub-img of sample img to do HOG calculation.
% PARAMETERS:
%   img:
%       input sample img.
%   cellpw, cellph:
%       cellpw and cellph are cell's pixel width and height respectively.
%   nblockw, nblockh:
%       nblockw and nblockh are block size counted by cells number in x and
%       y directions respectively.
% RETURN:
%   y:
%       proper sub-img for HOG calculation.

[M, N, K] = size(img);
% block size
blocksizeH = cellph*nblockh;
blocksizeW = cellpw*nblockw;
% fit to proper size for HOG calculation
newx = 1;
newy = 1;
newwidth = N;
newheight = M;
if mod(M,blocksizeH) ~= 0
    diff = M - fix(M/blocksizeH) * blocksizeH;
    upmargin = fix(diff / 2);
%     downmargin = diff - upmargin;
    newy = upmargin + newy;
    newheight = M - diff - 1;
end
if mod(N,blocksizeW) ~= 0
    diff = N - fix(N/blocksizeW) * blocksizeW;
    leftmargin = fix(diff / 2);
%     rightmargin = diff - leftmargin;
    newx = leftmargin + newx;
    newwidth = N - diff - 1;
end
% clip img 
y = imcrop(img, [newx, newy, newwidth, newheight]);
