function T2 = saveconfig(app)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

Settings = struct;
Settings.stTime = app.CH1TimeEditField.Value ;
Settings.ndTime = app.CH2TimeEditField.Value ;

Settings.stMarker = {app.stMarkerDropDown.Value} ;
Settings.ndMarker = {app.ndMarkerDropDown.Value} ;
Settings.stColor = num2str(app.CH1_COLOR.Color) ;
Settings.ndColor = num2str(app.CH2_COLOR.Color) ;

Settings.stChannel = app.CH1_DropDown.Value ;
Settings.ndChannel = app.CH2_DropDown.Value ;
Settings.PixelSize = app.pixelsizeumperpixEditField.Value ;
Settings.baseSize = app.basesizeEditField.Value ;
Settings.DisplayUnits = app.FiberMeasurementsUnitsDropDown.Value ;
Settings.Min_Fiber_Length = app.EditField.Value ;
Settings.Min_Fiber_Unit = app.DropDown.Value ;
Settings.Max_Gap = app.MaxGappxEditField.Value ;
Settings.Max_Gap_Unit = app.DropDown_2.Value;
Settings.Method = app.MethodDropDown.Value ;
Settings.PencilMode = app.PencilModeDropDown.Value ;
Settings.Thickness = app.PencilthicknessSpinner.Value ;
Settings.Pen_Color = num2str(app.AnnotColor.Color);
Settings.smoothness = app.PencilSmoothnessSpinner.Value ;
Settings.EraserMode = app.EraserModeDropDown.Value ;
Settings.Last_Path = string(app.Last_Path) ;


% add Keyboard Shortcuts
Settings.DisplayChannelEditField =  app.DisplayChannelEditField.Value ;
Settings.OverlayMaskEditField =  app.OverlayMaskEditField.Value ;
Settings.EditLineEditField =  app.EditLineEditField.Value ;
Settings.EraserEditField = app.EraserEditField.Value ;
Settings.DrawLineEditField =  app.DrawLineEditField.Value ;
Settings.PreviousImageEditField =  app.PreviousImageEditField.Value ;
Settings.NextImageEditField =  app.NextImageEditField.Value ;





T = struct2table(Settings,'Asarray',true) ;
T2 = rows2vars(T,'VariableNamingRule','preserve') ;
T2.Properties.RowNames = T2(:,1).Variables ;
T2(:,1) = [] ;

