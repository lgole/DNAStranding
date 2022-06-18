function skelprofile = skel_profiling_02(chRenhance,chGenhance,singleskelimg,Red_First)
% Author(s): Longjie LI, Laurent GOLE 
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

% a bit of a confusing mess, maybe one day need to rename properly.

if Red_First
    CH1COLOR = 'R' ;
    CH2COLOR = 'G' ;
else
    CH1COLOR = 'G' ;
    CH2COLOR = 'R' ;
end

skelprofile = struct;

[sorted_pxidx,custom_fiber_len] = skel_sequence_length(singleskelimg);

skelprofile.Fiber_Length = custom_fiber_len;

skelprofile.Rint = chRenhance(sorted_pxidx);
skelprofile.Rint_smooth = smoothdata(skelprofile.Rint);

skelprofile.Gint = chGenhance(sorted_pxidx);
skelprofile.Gint_smooth = smoothdata(skelprofile.Gint);

skelprofile.colorflag = color_determination...
    (skelprofile.Rint_smooth,skelprofile.Gint_smooth,Red_First);




if Red_First
    
    Rendpt = find_segment_endpoint(skelprofile.colorflag==2);
    Gendpt = find_segment_endpoint(skelprofile.colorflag==3);
else
    
    Rendpt = find_segment_endpoint(skelprofile.colorflag==3);
    Gendpt = find_segment_endpoint(skelprofile.colorflag==2);
end


segmentendpt = sortrows([Rendpt,Gendpt]')';

if isempty(segmentendpt)
    skelprofile.Fiber_Detail_Color = 'NA';
    skelprofile.Fiber_Detail_Length = nan;
else
    for i = 1:size(segmentendpt,2)
        singlesegmentimg = false(size(singleskelimg));
        singlesegmentimg(sorted_pxidx(segmentendpt(1,i):segmentendpt(2,i))) = true;
        [~,segmentlen] = skel_sequence_length(singlesegmentimg);
        skelprofile.Fiber_Detail_Length(i) = segmentlen;
        switch skelprofile.colorflag(segmentendpt(1,i))
            case 2
                skelprofile.Fiber_Detail_Color(i) = CH1COLOR;
            case 3
                skelprofile.Fiber_Detail_Color(i) = CH2COLOR;
        end
    end
end



if Red_First
    Ridx = skelprofile.Fiber_Detail_Color == CH1COLOR;
else
    Ridx = skelprofile.Fiber_Detail_Color == CH2COLOR;
end







skelprofile.Red_Length = sum(skelprofile.Fiber_Detail_Length(Ridx));
skelprofile.Green_Length = sum(skelprofile.Fiber_Detail_Length(~Ridx));


firstcolor = skelprofile.colorflag(1);
% if Red_First
%
% firstcolor = 2 ;
% % Rendpt = find_segment_endpoint(skelprofile.colorflag==2);
% % Gendpt = find_segment_endpoint(skelprofile.colorflag==3);
% else
%
% firstcolor = 3 ;
% % Rendpt = find_segment_endpoint(skelprofile.colorflag==3);
% % Gendpt = find_segment_endpoint(skelprofile.colorflag==2);
% end

% 6 DIFFERENT CLASSES OF FIBERS:
switch size(segmentendpt,2)
    case 1 % single color
        switch strcat(num2str(firstcolor),num2str(Red_First))
            case {'21','30'}
                skelprofile.Class = 'Stalled Replication Fork';
            case {'31','20'}
                skelprofile.Class = 'New Replication Fork';
        end
        
    case 2 % 2 colors
        skelprofile.Class = 'Replication Fork';
        
    case 3 % 3 colors
        switch strcat(num2str(firstcolor),num2str(Red_First))
            case {'21','30'}
                skelprofile.Class = 'Terminating Fork';
                
                
                
            case {'31','20'}
                %                 segmentlen1 = skelprofile.Fiber_Detail_Length(1);
                %                 segmentlen3 = skelprofile.Fiber_Detail_Length(3);
                % %                 deltalen = abs(segmentlen1-segmentlen3)/mean([segmentlen1,segmentlen3]);
                %                 if deltalen>asymmetricth
                %                     skelprofile.Class = 'Asymmetric Fork Progression';
                %                 else
                skelprofile.Class = 'Bidirectional Fork';
                %                 end
        end
        
    otherwise % more than 3 colors or empty
        skelprofile.Class = 'Multiple Origin Firing';
end


firstlabelidx = find(skelprofile.Fiber_Detail_Color=='R') ;
% firstlabelidx = find(~xor(Ridx,Red_First));

if length(firstlabelidx)<2
    skelprofile.Inter_Origin_Distance(1) = nan;
else
    for i = 2:length(firstlabelidx)
        skelprofile.Inter_Origin_Distance(i-1) = ...
            0.5*skelprofile.Fiber_Detail_Length(firstlabelidx(i)-2) + ...
            skelprofile.Fiber_Detail_Length(firstlabelidx(i)-1) + ...
            0.5*skelprofile.Fiber_Detail_Length(firstlabelidx(i));
    end
end


% Adding a mask image  for the colorflag for display in software:
rp =  regionprops(singleskelimg,'BoundingBox')    ;
color_detec_idx_img = ones(size(singleskelimg));
for p = 1:length(sorted_pxidx)
    color_detec_idx_img(sorted_pxidx(p)) = skelprofile.colorflag(p) ;
end
% if Red_First
color_detec = ind2rgb(color_detec_idx_img,[0 0 0;1 0 0;0 1 0]);
% else
% color_detec = ind2rgb(color_detec_idx_img,[0 0 0;0 1 0;1 0 0]);
% end

color_detec =  imcrop(color_detec,rp.BoundingBox+[-5 -5 10 10]) ;
skelprofile.Color_detec = color_detec ;


end