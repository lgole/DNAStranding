function app = Fibers_Toolbar(app)
% Author(s): Laurent GOLE
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.


% CREATE MAIN FIGURE TOOLBAR:
[app.AX_TB,~] = axtoolbar(app.UIAxes,{'pan','zoomin','zoomout','restoreview'});
disableDefaultInteractivity(app.UIAxes)


% DEFINE PENCIL BUTTON:
btn = axtoolbarbtn(app.AX_TB,'state');
btn.Icon = 'pencil.png';
btn.Tooltip = 'draw line';
btn.ValueChangedFcn = @Add_Line;

% DEFINE ERASER BUTTON:
btn = axtoolbarbtn(app.AX_TB,'state');
btn.Icon = 'eraser_24.png';
btn.Tooltip = 'erase line';
btn.ValueChangedFcn = @Rmv_Line;

% DEFINE EDIT BUTTON:
btn = axtoolbarbtn(app.AX_TB,'push');
btn.Icon = 'Lock_24.png';
btn.Tooltip = 'Edit line';
btn.ButtonPushedFcn  = @Edit_Line;
btn.Tag = 'lock' ;


% FOR INFO :
%  1 ToolbarPushButton     (Edit line)
%  2 ToolbarStateButton    (erase line)
%  3 ToolbarStateButton    (draw line)
%  4 ToolbarStateButton    (Pan)
%  5 ToolbarStateButton    (Zoom In)
%  6 ToolbarStateButton    (Zoom Out)
%  7 ToolbarPushButton     (Restore View)

% MODIFY RESTORE VIEW BEHAVIOR:
app.AX_TB.Children(end).ButtonPushedFcn  =  {@restoreview,app};
    function restoreview(e,d,app) %#ok<INUSL>
        % Default ButtonPushedFcn for the reset view toolbar button
        @(e,d)matlab.graphics.controls.internal.resetHelper(d.Axes,true);
        % Add our own end, which is to reset the axes manually
        app.UIAxes.XLim=[0, app.UIAxes.Children(end).XData(2)];
        app.UIAxes.YLim=[0, app.UIAxes.Children(end).YData(2)];
        e.Parent.Children(2).Value = 'off' ;
        e.Parent.Children(3).Value = 'off' ;
        e.Parent.Children(4).Value = 'off' ;
        e.Parent.Children(5).Value = 'off' ;
        e.Parent.Children(6).Value = 'off' ;
        zoom(app.UIAxes,'off')  ;
        pan(app.UIAxes,'off')   ;
    end

% DEFINE EDIT BUTTON CALLBACKS
    function  Edit_Line(src,event)
        src.Parent.Children(2).Value = 'off' ;
        src.Parent.Children(3).Value = 'off' ;
        src.Parent.Children(4).Value = 'off' ;
        src.Parent.Children(5).Value = 'off' ;
        src.Parent.Children(6).Value = 'off' ;
        zoom(app.UIAxes,'off')  ;
        pan(app.UIAxes,'off')   ;
        switch src.Tag
            case 'lock'
                src.Icon = 'Unlock_24.png';
                src.Tag = 'unlock' ;
            case 'unlock'
                src.Icon = 'Lock_24.png';
                src.Tag = 'lock' ;
        end
        % does this fail with no annotation?
        All_annot = event.Axes.Children(1:end-1);
        for i =1:numel(All_annot)
            switch src.Tag
                case 'lock'
                    All_annot(i).InteractionsAllowed = 'none'  ;
                    All_annot(i).Waypoints(:) = false   ;
                    
                case 'unlock'
                    All_annot(i).InteractionsAllowed = 'reshape'  ;
                    All_annot(i).Waypoints(round(1:numel(All_annot(i).Waypoints)/5:end)) = true ;
                    All_annot(i).Waypoints(end) = true ;
            end
        end
    end

% DEFINE PENCIL CALLBACKS:
    function Add_Line(src,event)
        src.Parent.Children(2).Value = 'off' ;
        src.Parent.Children(4).Value = 'off' ;
        src.Parent.Children(5).Value = 'off' ;
        src.Parent.Children(6).Value = 'off' ;
        drawnow
        src.Parent.Parent.Interactions = [];
        switch src.Value
            case 'off'
                enableDefaultInteractivity(src.Parent.Parent)
            case 'on'
                LampSwitch(app,'on','Drawing...')
                zoom(app.UIAxes,'off')
                pan(app.UIAxes,'off')
                disableDefaultInteractivity(event.Axes)
                
                
                
                
                
                
                switch src.Parent.Children(1).Tag
                    case 'lock'
                        Interactionallowed = 'none' ;
                    case 'unlock'
                        Interactionallowed = 'reshape' ;
                end
                
                switch app.PencilModeDropDown.Value
                    case app.PencilModeDropDown.Items{3}
                        %
%                         app.tmp1 =     drawfreehand( 'Parent',event.Axes,...
%                             'InteractionsAllowed','none','Color',app.AnnotColor.Color,'LineWidth',app.PencilthicknessSpinner.Value,...
%                             'DrawingArea',[event.Axes.XLim(1), event.Axes.YLim(1) , event.Axes.XLim(2)-event.Axes.XLim(1) , event.Axes.YLim(2)-event.Axes.YLim(1)]) ;
                        app.tmp1 =     drawfreehand( 'Parent',event.Axes,...
                            'Closed',false,'InteractionsAllowed',Interactionallowed,'FaceAlpha',0,...
                            'Color',app.AnnotColor.Color,'Smoothing',app.PencilSmoothnessSpinner.Value,...
                            'LineWidth',app.PencilthicknessSpinner.Value+12) ;
                        
                        
                        if size(app.tmp1.Position,1)<=1
                            delete(app.tmp1)
                                src.Value = 'off' ;
                LampSwitch(app,'off',' ')
                            return
                        end
                        
                           app =   localDetectionsSnap_ROI(app) ;
                        
%                         app =   localDetection_ROI(app) ;
                        delete(app.tmp1)
                        
                    case app.PencilModeDropDown.Items{2}
                        % POLYLINE MODE :
                        app.tmp1 =     drawpolyline( 'Parent',event.Axes,...
                            'InteractionsAllowed',Interactionallowed,'Color',app.AnnotColor.Color,'LineWidth',app.PencilthicknessSpinner.Value) ;
                        
                        if size(app.tmp1.Position,1)<=1
                            delete(app.tmp1)
                                src.Value = 'off' ;
                LampSwitch(app,'off',' ')
                            return
                        end
                        
                        
                        app.ROI =     drawfreehand( 'Parent',event.Axes,...
                            'Closed',false,'InteractionsAllowed',Interactionallowed,'FaceAlpha',0,...
                            'Color',app.AnnotColor.Color,'Smoothing',app.PencilSmoothnessSpinner.Value,...
                            'LineWidth',app.PencilthicknessSpinner.Value,'Position',app.tmp1.Position) ;
                        delete(app.tmp1)
                        
                        
                    case app.PencilModeDropDown.Items{1}
                        % FREEHAND MODE:
                        app.ROI =     drawfreehand( 'Parent',event.Axes,...
                            'Closed',false,'InteractionsAllowed',Interactionallowed,'FaceAlpha',0,...
                            'Color',app.AnnotColor.Color,'Smoothing',app.PencilSmoothnessSpinner.Value,...
                            'LineWidth',app.PencilthicknessSpinner.Value) ;
                        
                        
                        if size(app.ROI.Position,1)<=1
                            delete(app.ROI)
                            src.Value = 'off' ;
                            LampSwitch(app,'off',' ')
                            return
                        end
                        
                        
                        
                end
                
                
                % CHECK FOR INTERSECTION IN DRAWN LINE: can be unstable a  bit.
                if ~isempty(find(bwmorph(bwmorph(bwmorph(bwmorph(bwmorph(app.ROI.createMask,'bridge'),'close',5),'thin',Inf),'spur',1),'branchpoints'),1))
                    uialert(app.UIFigure,'Fibers are not allowed to contain Intersections.','Invalid Fiber');
                    delete(app.ROI)
                    src.Value = 'off' ;
                    LampSwitch(app,'off',' ')
                    return
                end
                
                app.ROI.Tag = 'Fiber_ROI' ;
                app.ROI.UserData = app.AX_TB ;
                
                N = numel(event.Axes.Children(1:end-1)) ;
%                 app.ROI.Label = num2str(N) ;
                app.ROI.LabelVisible = 'hover' ;
                
                app.ROI.Deletable = true ;
                ROI_ClickedListener(app,app.ROI)
                
                src.Value = 'off' ;
                LampSwitch(app,'off',' ')
        end
    end

% DEFINE ERASER CALLBACK:
    function Rmv_Line(src,event)
        % the DELETE MAIN FUNNCTION IS STORED IN ROILISTENER.m
        src.Parent.Children(3).Value = 'off' ;
        src.Parent.Children(4).Value = 'off' ;
        src.Parent.Children(5).Value = 'off' ;
        src.Parent.Children(6).Value = 'off' ;
        src.Parent.Parent.Interactions = [];
        switch src.Value
            case 'off'
                LampSwitch(app,'off',' ')
                enableDefaultInteractivity(src.Parent.Parent)
            case 'on'
                LampSwitch(app,'on','Erasing...')
                zoom(app.UIAxes,'off')
                pan(app.UIAxes,'off')
                disableDefaultInteractivity(event.Axes)
                
                switch app.EraserModeDropDown.Value
                    case app.EraserModeDropDown.Items{1}
                        
                        % this is define in the ROICLICKED.m LISTENER
                        
                    case app.EraserModeDropDown.Items{2}
                        %
                        app.tmp1 =     drawfreehand( 'Parent',event.Axes,...
                            'InteractionsAllowed','none','Color',app.AnnotColor.Color,'LineWidth',app.PencilthicknessSpinner.Value,...
                            'DrawingArea',[event.Axes.XLim(1), event.Axes.YLim(1) , event.Axes.XLim(2)-event.Axes.XLim(1) , event.Axes.YLim(2)-event.Axes.YLim(1)]) ;
                        
                        app =   localErase_ROI(app) ;
                        delete(app.tmp1)
                        
                        src.Value = 'off' ;
                        LampSwitch(app,'off',' ')
                end
        end
    end

% % CREATE 2nd FIGURE TOOLBAR:
[AX2tb] = axtoolbar(app.UIAxes2);
AX2tb.Visible = 'off';
disableDefaultInteractivity(app.UIAxes2)
% % CREATE 3rd FIGURE TOOLBAR:
[AX3tb] = axtoolbar(app.UIAxes3);
AX3tb.Visible = 'off';
disableDefaultInteractivity(app.UIAxes3)
% % CREATE 4th FIGURE TOOLBAR:
[AX4tb] = axtoolbar(app.UIAxes4);
AX4tb.Visible = 'off';
disableDefaultInteractivity(app.UIAxes4)
end