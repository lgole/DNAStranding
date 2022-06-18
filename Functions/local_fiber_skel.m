function skelimg = local_fiber_skel(fiberimg)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

% this function just used in manual auto detection of fibers:

opsz2 = 3;
fiberimg = imdilate(fiberimg,strel('disk',opsz2));

% fill small holes otherwise it will affect skeletonization
fiberfill = imfill(fiberimg,'holes');
largehole = bwareaopen(xor(fiberfill,fiberimg),20);
fiberfill(largehole) = false;
fiberimg = bwmorph(fiberfill,'spur');

fiberimg = imerode(fiberimg,strel('disk',2)) ;

skelimg = bwskel(bwskel(fiberimg,'MinBranchLength',10),'MinBranchLength',10);
