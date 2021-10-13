function colorflag = color_determination(Rint,Gint,Red_First,deltaint_th)
% Author(s): Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

if nargin<4 || isempty(deltaint_th)
    deltaint_th = 10/100; % intensity difference threshold
end

small_segment_th = 5;
% if there's a short segment between two long different-color segments, it
% will be regarded as noise and its color will be reversed
% doesn't work for consecutive short segments

deltaint = 2*abs(Rint-Gint)./(Rint+Gint);

if all(deltaint<=deltaint_th)
    if deltaint_th<1e-8
        colorflag = ones(size(Rint));
    else
        colorflag = color_determination(Rint,Gint,deltaint_th*0.9,Red_First);
    end
    return
end

colorflag = ones(size(Rint));

largediffidx = deltaint>deltaint_th;
Ridx = (Rint>Gint) & largediffidx;
Gidx = (Gint>Rint) & largediffidx;
% 2:red, 3:green



if Red_First
    colorflag(Ridx) = 2;
    colorflag(Gidx) = 3;
    
else
    colorflag(Ridx) = 3;
    colorflag(Gidx) = 2;
end
%
% colorflag(Ridx) = 2;
% colorflag(Gidx) = 3;

smalldiffidx = ~largediffidx;

% find start and end points of each small-intensity-difference segment
smalldiff_segment = find_segment_endpoint(smalldiffidx);


% assign color to small-intensity-difference segments
for i = 1:size(smalldiff_segment,2)
    if smalldiff_segment(1,i)==1 % segment at start
        
        colorflag(smalldiff_segment(1,i):smalldiff_segment(2,i)) =...
            colorflag(smalldiff_segment(2,i)+1);
        
    elseif smalldiff_segment(2,i)==length(colorflag) % segment at the end
        
        colorflag(smalldiff_segment(1,i):smalldiff_segment(2,i)) =...
            colorflag(smalldiff_segment(1,i)-1);
        
    elseif colorflag(smalldiff_segment(1,i)-1)==...
            colorflag(smalldiff_segment(2,i)+1) % 2 same-color-neighbors
        
        colorflag(smalldiff_segment(1,i):smalldiff_segment(2,i)) =...
            colorflag(smalldiff_segment(1,i)-1);
        
    else % 2 different-color-neighbors
        
        midpoint = round(mean(smalldiff_segment(:,i)));
        colorflag(smalldiff_segment(1,i):midpoint) =...
            colorflag(smalldiff_segment(1,i)-1);
        colorflag(midpoint:smalldiff_segment(2,i)) =...
            colorflag(smalldiff_segment(2,i)+1);
    end
end


% reverse short segment's color
if Red_First
    
    Rendpt = find_segment_endpoint(colorflag==2);
    Gendpt = find_segment_endpoint(colorflag==3);
else
    Rendpt = find_segment_endpoint(colorflag==3);
    Gendpt = find_segment_endpoint(colorflag==2);
end

%
% Rendpt = find_segment_endpoint(colorflag==2);
% Gendpt = find_segment_endpoint(colorflag==3);
segmentendpt = sortrows([Rendpt,Gendpt]')';

for i = 1:size(segmentendpt,2)
    if segmentendpt(2,i)-segmentendpt(1,i) <= small_segment_th-1
        colorflag(segmentendpt(1,i):segmentendpt(2,i)) = ...
            5 - colorflag(segmentendpt(1,i):segmentendpt(2,i));
    end
end


end