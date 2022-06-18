function app = localDetection_ROI(app)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

warning('off', 'MATLAB:polyshape:repairedBySimplify') ;
app.tmp1.Position = round(app.tmp1.Position) ;
[xlim,ylim] = boundingbox(polyshape(app.tmp1.Position)) ;
BB = [xlim(1) ylim(1) xlim(2)-xlim(1) ylim(2)-ylim(1)] ;

Mask = app.tmp1.createMask ;
chM = imcrop(Mask,BB) ;
chR = imadjust(imcrop(app.Im_CH1,BB),[]) ;
chG = imadjust(imcrop(app.Im_CH2,BB),[]) ;

chR(~chM) = 0 ;
chG(~chM) = 0 ;

fiberimg = fiber_detection(chR,chG,'frangi','gmm') ;
fiberimg(~chM) = 0;
skelimg = local_fiber_skel(fiberimg) ;

% select only the largest object, to avoid multiple ROI with same Label?
singleskelimg = imerode(imdilate(skelimg,strel('disk',10)),strel('disk',10)) ;
Ar = regionprops((singleskelimg),'Area') ;
idx = find([Ar.Area] == max([Ar.Area]) ) ;
singleskelimg = ismember(bwlabel(singleskelimg),idx);  

singleskelimg = bwmorph(bwmorph(bwmorph(bwmorph(singleskelimg,'bridge'),'close',20),'thin',Inf),'spur',1) ;
singleskelimg = bwareaopen(singleskelimg,5) ;

tmpBW = zeros([size(app.Im_CH1,1),size(app.Im_CH1,2)],'logical') ;
tmpBW(ylim(1):ylim(1)+size(singleskelimg,1)-1, xlim(1):xlim(1) +size(singleskelimg,2)-1) = singleskelimg;


% change here so that only the longest fiber is selected rest shld be
% discarded

blocations = bwboundaries(bwmorph(tmpBW,'Thin',Inf),'noholes');
switch app.AX_TB.Children(1).Tag
    case 'lock'
        InteractionsAllowed = 'none'  ;
    case 'unlock'
        InteractionsAllowed = 'reshape'  ;
end
for ind = 1:numel(blocations)
    % Convert to x,y order.
    pos = blocations{ind};
    pos = fliplr(pos);
    pos =  pos(1:floor(numel(pos(:,1))/2)+1,:) ;
    pos =  pos(1:1:end,:) ;
    WP  =   false([size(pos,1),1]) ;
    WP(1:15:end) =  true ;
    WP(end) = true ;
    % Create a polyline ROI.
    app.ROI=   drawfreehand('Parent',app.AX_TB.Parent,...
        'Closed',false,'FaceAlpha',0,...
        'Position', pos,'Color',app.AnnotColor.Color,...
        'LineWidth',app.PencilthicknessSpinner.Value,...
        'InteractionsAllowed',InteractionsAllowed,'Waypoints',WP);
    app.ROI.Tag = 'Fiber_ROI' ;
    app.ROI.UserData = app.AX_TB ;
    ROI_ClickedListener(app,app.ROI)
end