function app  = Update_Image2(app)
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

app.UIAxes.Children(end).CData = imadjust(B,[0 1-app.Slider.Value]) ;
app.UIAxes.YDir = 'normal' ;