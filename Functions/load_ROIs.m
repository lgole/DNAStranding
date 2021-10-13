function app = load_ROIs(app)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

FiberOutput_path  = getOutput_path(app) ;

% delete existing ROIS just in case before loading ROIS:
delete(app.UIAxes.Children(1:end-1))

if exist([FiberOutput_path filesep app.Label_ImageName.Text '_roi.mat'],'file')==2
    tmp = load([FiberOutput_path filesep app.Label_ImageName.Text '_roi.mat']) ;
    RP = tmp.RP ;
    RPL = tmp.RPL ; 
else
    RP = [];
    RPL = [] ;
    disp('no ROIs to load.')
    return
end

switch app.AX_TB.Children(1).Tag
    case 'lock'
        InteractionsAllowed = 'none'  ;
    case 'unlock'
        InteractionsAllowed = 'reshape'  ;
end

for i = 1:numel(RP)
    
    
    pos = RP{i};
    WP  =   false([size(pos,1),1]) ;
    WP(round(1:numel(WP)/5:end))=  true ;
    WP(end) = true ;
    
    app.ROI=   drawfreehand('Parent',app.AX_TB.Parent,...
        'Closed',false,'FaceAlpha',0,...
        'Position', pos,'Color',app.AnnotColor.Color,...
        'LineWidth',app.PencilthicknessSpinner.Value,...
        'InteractionsAllowed',InteractionsAllowed,'Waypoints',WP);
    app.ROI.Tag = 'Fiber_ROI' ;
  
    app.ROI.UserData = app.AX_TB ;
    % this here may be issue?
    %   app.ROI.Label = [num2str(numel(blocations)-ind)] ;
    
%     app.ROI.Label = [num2str(i)] ;
    app.ROI.Label = RPL{i} ;
    app.ROI.LabelVisible = 'hover' ;
    ROI_ClickedListener(app,app.ROI)
end