function app = DNA_detection(app)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

% MAX GAP LENGTH AND MIN SKELETON LENGTH:
pxumval =  app.pixelsizeumperpixEditField.Value ;
kbval = app.basesizeEditField.Value ;

switch app.DropDown_2.Value
    case app.DropDown_2.Items{1}
        maxgap = app.MaxGappxEditField.Value;
    case app.DropDown_2.Items{2}
        maxgap = app.MaxGappxEditField.Value /   pxumval ;
    case app.DropDown_2.Items{3}
        maxgap = app.MaxGappxEditField.Value /   pxumval / kbval ;
end

switch app.DropDown.Value
    case app.DropDown.Items{1}
        skellength = app.EditField.Value;
    case app.DropDown.Items{2}
        skellength = app.EditField.Value /   pxumval ;
    case app.DropDown.Items{3}
        skellength = app.EditField.Value /   pxumval / kbval ;
end

%%%%%%%%%%%%% DETECTION AND FIBER SAVING%%%%%%%%%%%%%
if ~strcmpi(app.MethodDropDown.Value,app.MethodDropDown.Items{5})
    switch lower(app.MethodDropDown.Value)
        case 'frangi gmm'
            prefilter_method = 'frangi' ;
            threshold_method = 'GMM'    ;
        case 'frangi otsu'
            prefilter_method = 'frangi' ;
            threshold_method = 'otsu'    ;
        case 'gmm'
            prefilter_method = 'none' ;
            threshold_method = 'GMM'    ;
        case 'otsu'
            prefilter_method = 'none' ;
            threshold_method = 'otsu'    ;
            
    end
    fiberimg =  fiber_detection(app.Im_CH1,app.Im_CH2,prefilter_method,threshold_method) ;
    if ~isempty(fiberimg)
    skelimg = fiber_skel(fiberimg,maxgap,skellength) ;
    else
        return
    end
    
elseif strcmpi(app.MethodDropDown.Value,app.MethodDropDown.Items{5})
    [fiberimg1, fiberimg2] = fiber_detectionBEST(app.Im_CH1,app.Im_CH2) ;
    skelimg1 = fiber_skel(fiberimg1,maxgap,skellength) ;
    skelimg2 = fiber_skel(fiberimg2,maxgap,skellength) ;
    %
    skelimg = (skelimg1 | skelimg2) ;
    
%     
% edpts = find(bwmorph(logical(skelimg),'endpoints'));
% 
% if length(edpts)==1
%     pxidx = edpts;
%     len = 1;
% %     return
% elseif length(edpts)>2
% %     errordlg('This function do not support skeleton with branches.','Error')
% disp('weird')
%     pxidx = 0;
%     len = 0;
% %     return
% end
%     
    
    
%      if ~isempty(find(bwmorph(bwmorph(bwmorph(bwmorph(bwmorph(skelimg,'bridge'),'close',5),'thin',Inf),'spur',1),'branchpoints'),1))
%                     uialert(app.UIFigure,'Fibers are not allowed to contain Intersections.','Invalid Fiber');
% %                     evt.Source.Position = evt.PreviousPosition ; 
%                 end
end

app.Im_BW = skelimg ;
% convert the binary generated fiber skeleton mask to Region of Interests:
app = BW2ROIs(app) ;