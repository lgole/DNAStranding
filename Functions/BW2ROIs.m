function app = BW2ROIs(app)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

app.Im_BW  = app.Im_BW(:,:,1)  ;
% RECREATE ROIS PolyLine based on Binary Mask:
blocations = bwboundaries(bwmorph(app.Im_BW,'Thin',Inf),'noholes');
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
    WP(1:20:end) =  true ;
    WP(end) = true ;
    % Create a polyline ROI.
    app.ROI=   drawfreehand('Parent',app.AX_TB.Parent,...
        'Closed',false,'FaceAlpha',0,...
        'Position', pos,'Color',app.AnnotColor.Color,...
        'LineWidth',app.PencilthicknessSpinner.Value,...
        'InteractionsAllowed',InteractionsAllowed,'Waypoints',WP);
    app.ROI.Tag = 'Fiber_ROI' ;
    app.ROI.UserData = app.AX_TB ;
  %  app.ROI.Label = [num2str(numel(blocations)-ind)] ;
  %HERE must recreate the Labels:
%    app.ROI.Label = [num2str(ind)] ;
  
  app.ROI.LabelVisible = 'hover' ;
    ROI_ClickedListener(app,app.ROI)
end
if ~app.OverlaymaskCheckBox.Value
    app.OverlaymaskCheckBox.Value=1 ;
end