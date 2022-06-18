function app =loadconfig(T2,app)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

C = table2cell(T2(:,1)) ;

app.Last_Path = C{22} ;
app.stMarkerDropDown.Value = C{3} ;
app.ndMarkerDropDown.Value = C{4} ;
app.CH1_COLOR.Color = str2num(C{5}) ;
app.CH2_COLOR.Color = str2num(C{6});
app.CH1TimeEditField.Value = str2num(C{1}) ;
app.CH2TimeEditField.Value = str2num(C{2}) ;
app.CH1_DropDown.Value = C{7} ;
app.CH2_DropDown.Value = C{8} ;
app.pixelsizeumperpixEditField.Value = str2num(C{9}) ;
app.basesizeEditField.Value = str2num(C{10}) ;
app.FiberMeasurementsUnitsDropDown.Value = C{11} ;
app.EditField.Value  = str2num(C{12}) ;
app.DropDown.Value = C{13} ;
app.MaxGappxEditField.Value  = str2num(C{14}) ;
app.DropDown_2.Value = C{15};
app.MethodDropDown.Value = C{16} ;
app.PencilModeDropDown.Value = C{17} ;
app.PencilthicknessSpinner.Value = str2num(C{18}) ;
app.AnnotColor.Color = str2num(C{19});
app.PencilSmoothnessSpinner.Value  = str2num(C{20}) ;
app.EraserModeDropDown.Value = C{21} ;

app.CH1Button.Text = app.stMarkerDropDown.Value ; 
app.CH2Button.Text = app.ndMarkerDropDown.Value ;


% KEYBAORD SHORTCUTS: 

% add Keyboard Shortcuts
app.DisplayChannelEditField.Value= C{23} ;  
app.OverlayMaskEditField.Value= C{24} ;
app.EditLineEditField.Value= C{25} ;
app.EraserEditField.Value = C{26};
app.DrawLineEditField.Value = C{27};
app.PreviousImageEditField.Value = C{28};
app.NextImageEditField.Value = C{29};



