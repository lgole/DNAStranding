function app = DNAfibers_KEYBOARDSHORTCUTS(app,event)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

switch app.TabGroup.SelectedTab
    case app.ViewTab
        % trigger keyboard callbacks only when the view tab is active
    otherwise
        return
end



LampSwitch(app,'on','Keybord callback...')
drawnow
key = event.Key;
% KEYBOARD SHORTCUTS:
if ~isempty(event.Modifier)
    switch event.Modifier{1}
        case 'shift'
            key = upper(key) ;
    end
end


% MAIN CALLBACKS FOR KEYBOARD SHORTCUTS:
switch key
    
    
    case app.DisplayChannelEditField.Value
        Listbuttons = { app.DisplayOptionsButtonGroup.Buttons.Text}  ;
        IDX=   find( contains(Listbuttons , app.DisplayOptionsButtonGroup.SelectedObject.Text)) ;
        if IDX<4
            app.DisplayOptionsButtonGroup.SelectedObject = app.DisplayOptionsButtonGroup.Buttons(IDX+1) ;
        else
            app.DisplayOptionsButtonGroup.SelectedObject = app.DisplayOptionsButtonGroup.Buttons(1) ;
        end
        app.DisplayOptionsButtonGroup.SelectionChangedFcn(app, event)
        
        
        
        
    case app.OverlayMaskEditField.Value
        if app.OverlaymaskCheckBox.Value==1
            app.OverlaymaskCheckBox.Value = 0 ;
        else
            app.OverlaymaskCheckBox.Value=1 ;
        end
        app.DisplayOptionsButtonGroup.SelectionChangedFcn(app, event)
        
    case app.DrawLineEditField.Value
        
        IDX  =  3  ;
        switch app.AX_TB.Children(IDX).Value
            case 'off'
                zoom(app.UIAxes,'off')
                pan(app.UIAxes,'off')
                disableDefaultInteractivity(app.AX_TB.Parent)
                app.AX_TB.Children(IDX).Value = 'on' ;
                %                create my  own  event
                event = [] ;
                event.Source = app.AX_TB.Children(IDX) ;
                event.Axes =app.AX_TB.Parent ;
                event.EventName ='ValueChanged' ;
                event.Value = 'on'  ;
                app.AX_TB.Children(IDX).ValueChangedFcn( app.AX_TB.Children(IDX),event)
                
            case 'on'
                %                     do nothing
        end
        
    case app.EraserEditField.Value
        
        IDX  =  2 ;
        switch app.AX_TB.Children(IDX).Value
            case 'off'
                zoom(app.UIAxes,'off')
                pan(app.UIAxes,'off')
                disableDefaultInteractivity(app.AX_TB.Parent)
                app.AX_TB.Children(IDX).Value = 'on' ;
                %                create my  own  event
                event = [] ;
                event.Source = app.AX_TB.Children(IDX) ;
                event.Axes =app.AX_TB.Parent ;
                event.EventName ='ValueChanged' ;
                event.Value = 'on'  ;
                app.AX_TB.Children(IDX).ValueChangedFcn( app.AX_TB.Children(IDX),event)
                
            case 'on'
                %                     do nothing
        end
        
        
        
    case app.EditLineEditField.Value
        IDX  = 1  ;
        
        event = [] ;
        event.Source = app.AX_TB.Children(IDX) ;
        event.Axes =app.AX_TB.Parent ;
        event.EventName ='ValueChanged' ;
        app.AX_TB.Children(IDX).ButtonPushedFcn( app.AX_TB.Children(IDX),event)
        
        
        
        
        % Left Arrow Callback
    case app.PreviousImageEditField.Value
        switch app.TabGroup.SelectedTab
            case app.ViewTab
                evt = [] ;
                evt.Source = app.Image6 ;
                evt.EventName = 'ImageClicked' ;
                app.Image6.ImageClickedFcn(app,evt)
                figure(app.UIFigure) ;
        end
        
        
        % Right Arrow
    case app.NextImageEditField.Value
        switch app.TabGroup.SelectedTab
            case app.ViewTab
                evt = [] ;
                evt.Source = app.Image7 ;
                evt.EventName = 'ImageClicked' ;
                app.Image7.ImageClickedFcn(app,evt)
                figure(app.UIFigure) ;
        end
end % switch Key end

LampSwitch(app,'off',' ')


