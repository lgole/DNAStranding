function endpoints = find_segment_endpoint(array1)
% this function can find the start & end points of each 1's segment
% (non-zero segment) in array1
% input must be row or column vector
% output contains 2 rows, 1st row is start pt and 2nd row is end pt
% Author(s): Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

onesidx = find(array1);

if isempty(onesidx)
    endpoints = [];
    return
end

if iscolumn(onesidx)
    onesidx = onesidx';
end

if length(onesidx)==1
    segment_stpt = onesidx;
    segment_edpt = onesidx;
else
    segment_stpt = zeros(size(onesidx));
    segment_edpt = zeros(size(onesidx));
    for i = 2:length(onesidx)
        if onesidx(i)-onesidx(i-1)~=1
            segment_stpt(i) = onesidx(i);
            segment_edpt(i-1) = onesidx(i-1);
        end
    end
    segment_stpt(1) = onesidx(1);
    segment_edpt(i) = onesidx(i);
    segment_stpt = segment_stpt(segment_stpt~=0);
    segment_edpt = segment_edpt(segment_edpt~=0);
end

endpoints = [segment_stpt;segment_edpt];
end