function skelimg = fiber_skel(fiberimg,maxgap,skel_len_th)
% Author(s): Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

remove_edge_fibers = true;
remove_branch_fibers = true;
remove_short_skel = true;

Minareath = 500;  % min fiber area th
Min_axis_L_th = 30; % min fiber major axis length th
Eccth = (21^0.5)/5; % eccentricity th
% if a:b=2, e=(3^0.5)/2; if a:b=2.5,then e=(21^0.5)/5; if a:b=3, e=(8^0.5)/3
Solidth = 0.2; % solidity th
distance_to_edge_th = 5;

aa = bwpropfilt(fiberimg,'Eccentricity',[Eccth,Inf]); % for elongated fiber
bb = bwpropfilt(fiberimg,'Solidity',[0,Solidth]); % for circular fiber
fiberimg = aa | bb;

fiberimg = bwareaopen(fiberimg,Minareath);

fiberimg = bwpropfilt(fiberimg,'MajorAxisLength',[Min_axis_L_th,Inf]);

if remove_edge_fibers
    edgering = true(size(fiberimg));
    edgering(distance_to_edge_th+1:size(edgering,1)-distance_to_edge_th,...
        distance_to_edge_th+1:size(edgering,2)-distance_to_edge_th) = false;
    edgering = edgering | fiberimg;
    edgering = bwpropfilt(edgering,'ConvexArea',1);
    fiberimg(edgering) = false;
end


% thick is very helpful for gap bridging
% operator size 1 for thick, operator size 2 for dilation
% opsz2 will always be 1
% opsz1 + 1 + opsz2 = max_gap*0.5 (thick will expand 1 extra px)
if maxgap<1
    opsz1 = 0;
    opsz2 = 0;
elseif maxgap<=4
    opsz1 = 0;
    opsz2 = ceil(maxgap/2);
else
    opsz1 = ceil(maxgap/2)-2;
    opsz2 = 1;
end

fiberimg = imdilate(bwmorph(fiberimg,'thicken',opsz1),strel('disk',opsz2));

% fill small holes otherwise it will affect skeletonization
fiberfill = imfill(fiberimg,'holes');
largehole = bwareaopen(xor(fiberfill,fiberimg),20);
fiberfill(largehole) = false;
fiberimg = bwmorph(fiberfill,'spur');

% skel twice to protect the fiber that is very good but somehow having a
% short branch. skel twice to remove the branch point introduced by first skel
skelimg = bwskel(bwskel(fiberimg,'MinBranchLength',10),'MinBranchLength',10);

if remove_short_skel
    skelimg = bwareaopen(skelimg,skel_len_th);
end

if remove_branch_fibers
    branchpt = find(bwmorph(skelimg,'branchpoints'));
    if ~isempty(branchpt)
        skelprop = regionprops(skelimg,'PixelIdxList');
        for i =1:length(skelprop)
            if intersect(skelprop(i).PixelIdxList,branchpt)
                skelimg(skelprop(i).PixelIdxList) = false;
            end
        end
    end
end


end