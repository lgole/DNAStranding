function app = resetconfig(app)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

% DEFINE DEFAULT CONFIG HERE
app.Last_Path = '' ;
app.stMarkerDropDown.Value = 'CldU' ;
app.ndMarkerDropDown.Value = 'IdU' ;
app.CH1_COLOR.Color = [1 0 0] ;
app.CH2_COLOR.Color = [0 1 0] ;
app.CH1TimeEditField.Value = 30 ;
app.CH2TimeEditField.Value = 30 ;
app.CH1_DropDown.Value = 'CH1' ;
app.CH2_DropDown.Value = 'CH2' ;
app.pixelsizeumperpixEditField.Value = 0.103 ;
app.basesizeEditField.Value = 2.59 ;
app.FiberMeasurementsUnitsDropDown.Value = 'pixels' ;
app.EditField.Value  = 20 ;
app.DropDown.Value = 'pixels' ;
app.MaxGappxEditField.Value  = 5 ;
app.DropDown_2.Value = 'pixels' ;
app.MethodDropDown.Value = 'Optimal' ;
app.PencilModeDropDown.Value = 'Freehand' ;
app.PencilthicknessSpinner.Value = 2 ;
app.AnnotColor.Color = [0.07451     0.62353           1] ;
app.PencilSmoothnessSpinner.Value  = 3 ;
app.EraserModeDropDown.Value = 'Object' ;


app.CH1Button.Text = app.stMarkerDropDown.Value ; 
app.CH2Button.Text = app.ndMarkerDropDown.Value ;



% KEYBOARD SHORTCUTS DEFAULT: 

% add Keyboard Shortcuts
app.DisplayChannelEditField.Value = 'q' ;
app.OverlayMaskEditField.Value = 'm' ;
app.EditLineEditField.Value = 'w' ;
app.EraserEditField.Value = 'e' ;
app.DrawLineEditField.Value = 'd' ;
app.PreviousImageEditField.Value = 'leftarrow' ;
app.NextImageEditField.Value = 'rightarrow' ;



