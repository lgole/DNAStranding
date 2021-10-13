function ROI_ClickedListener(app,ROI)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

% SEE : ADDLISTENER binds the listener's lifecycle to the object that is the 
%   source of the event.  Unless you explicitly delete the listener, it is
%   destroyed only when the source object is destroyed.  To control the
%   lifecycle of the listener independently from the event source object, 
%   use listener or the event.listener constructor to create the listener.
addlistener(ROI,'ROIClicked',@clickCallback);
addlistener(ROI,'ROIMoved',@clickCallback);

% The allevents callback function displays at the command line the previous position and the current position of the Freehand ROI.

    function clickCallback(src,evt)
        evname = evt.EventName;
        switch(evname)
            case{'ROIClicked'}
                
                switch evt.SelectionType
                    % only for left click
                    case 'left'
                        TB  = src.UserData ;
                        AllStateButtons =  findobj(src.UserData.Children,'Type','toolbarstatebutton') ;
                        
                        if src.UserData.Children(2).Value == 'on'
%                             disp('eraser triggered')
                            fiberBlink(src)
                            
                            warning('off','MATLAB:callback:DeletedSource')
                            delete(src)
                        end
                        
                    case 'right'
                        
                        
%                         if numel( findobj(app.UIFigure,'type','uicontextmenu'))
%                             delete( findobj(app.UIFigure,'type','uicontextmenu'))
%                         end
%                         
%                          disp('do nothing.')
%                          evt.Source.Waypoints(evt.CurrentSelected)=1  ; 
%                         if  evt.CurrentSelected==1
%                              evt.Source.Waypoints(evt.CurrentSelected+1)=1;
%                         elseif  evt.CurrentSelected <=numel(evt.Source.Waypoints)
%                            evt.Source.Waypoints(evt.CurrentSelected)=1;
%                         end
                        
                end
                
            case{'ROIMoved'}
                
                      TB  = src.UserData ;
                        AllStateButtons =  findobj(src.UserData.Children,'Type','toolbarstatebutton') ;
                        
%                         if src.UserData.Children(1).Value == 'on'
%                             
%                         else
                
                disp(['ROI moved Previous Position: ' mat2str(evt.PreviousPosition)]);
                disp(['ROI moved Current Position: ' mat2str(evt.CurrentPosition)]);
                           % CHECK FOR INTERSECTION IN DRAWN LINE: can be unstable a  bit.
                if ~isempty(find(bwmorph(bwmorph(bwmorph(bwmorph(bwmorph(evt.Source.createMask,'bridge'),'close',5),'thin',Inf),'spur',1),'branchpoints'),1))
                    uialert(app.UIFigure,'Fibers are not allowed to contain Intersections.','Invalid Fiber');
                    evt.Source.Position = evt.PreviousPosition ; 
                end
                
                
%                         end
        end
    end




end