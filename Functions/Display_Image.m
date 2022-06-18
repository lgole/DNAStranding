function app = Display_Image(app)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

if app.OverlaymaskCheckBox.Value
    for j = 1:numel(app.UIAxes.Children(1:end-1))
        app.UIAxes.Children(j).Visible = 'on' ;
    end
else
    for j = 1:numel(app.UIAxes.Children(1:end-1))
        app.UIAxes.Children(j).Visible = 'off' ;
    end
end

switch app.DisplayOptionsButtonGroup.SelectedObject
    case app.RGBbutton
        B =    app.Im_RGB ;
        
    case app.CH1Button
        B =    app.Im_CH1 ;
        
    case app.CH2Button
        B =   app.Im_CH2 ;
        
    case app.CH3Button
        B = app.Im_CH3 ;
end
%
% % display Image per se:
% imagesc Actually clear all ROIS
if size(B,3)>3
    B = zeros([size(B,1:2),3]) ;
    
    imagesc(app.UIAxes,B)
    return
else
    imagesc(app.UIAxes,B)
end

app.UIAxes.Children(end).CData = imadjust(B,[0 1-app.Slider.Value]) ;

try
    app = load_ROIs(app) ;
catch
end

app.UIAxes.YDir = 'normal' ;
Update_Image2(app);
drawnow
axis(app.UIAxes, 'equal');
axis(app.UIAxes, 'off') ;