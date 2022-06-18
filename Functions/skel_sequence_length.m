function [pxidx,len] = skel_sequence_length(BW)
% Author(s): Longjie LI, Laurent GOLE 
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

edpts = find(bwmorph(logical(BW),'endpoints'));

if length(edpts)==1
    pxidx = edpts;
    len = 1;
    return
elseif length(edpts)>2
%     errordlg('This function do not support skeleton with branches.','Error')
    pxidx = 0;
    len = 0;
    return
end

[I,J] = find(BW);
if isrow(I)
    allpixelsub = [I;J]';
else
    allpixelsub = [I,J];
end

[edsub1,edsub2] = ind2sub(size(BW),edpts);
if isrow(edsub1)
    edptsub = [edsub1;edsub2]';
else
    edptsub = [edsub1,edsub2];
end

pxidx = zeros(size(allpixelsub));
pxidx(1,:) = edptsub(1,:);
[~,~,istart] = intersect(pxidx(1,:),allpixelsub,'rows');
allpixelsub(istart,:) = [];
for i = 2:size(pxidx,1)
    [inter,~,ib] = intersect(pxidx(i-1,:)+[0,1;0,-1;1,0;-1,0],...
        allpixelsub,'rows');% neighbor px
    if isempty(inter)
        [inter,~,ib] = intersect(pxidx(i-1,:)+[1,1;1,-1;-1,1;-1,-1],...
            allpixelsub,'rows');% diagonal-neighbor px
    end
    pxidx(i,:) = inter;
    allpixelsub(ib,:) = [];
end

diffpx = diff(pxidx);
diagonal_dist = all(diffpx,2);
pxidx = sub2ind(size(BW),pxidx(:,1),pxidx(:,2));
len = length(pxidx)+(sqrt(2)-1).*(sum(diagonal_dist)+mean([diagonal_dist(1),diagonal_dist(end)]));
end
