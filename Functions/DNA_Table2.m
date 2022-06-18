function app =DNA_Table2(app,IDX)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

inputtable = struct2table(app.Fibers_properties,'AsArray',true);

% 1st marker and it s associated color:
if isequal(app.CH1_COLOR.Color,[1 0 0])
    CH1C = 'R' ;
elseif isequal(app.CH1_COLOR.Color,[0 1 0])
    CH1C = 'G' ;
end
% 2nd marker and it s associated color:
% if isequal(app.CH2_COLOR.Color,[1 0 0])
%     CH2C = 'R' ;
% elseif isequal(app.CH2_COLOR.Color,[0 1 0])
%     CH2C = 'G' ;
% end


pxumval =  app.pixelsizeumperpixEditField.Value ;
kbval = app.basesizeEditField.Value ;

Units = app.FiberMeasurementsUnitsDropDown.Value;
%   pixels
%   µm
%   kb
%   %
% depending on display Units: (not for % though)
switch Units   
    case app.FiberMeasurementsUnitsDropDown.Items{1}
        COEF = 1 ;
        Unitsname = 'px';
    case app.FiberMeasurementsUnitsDropDown.Items{2}
        COEF = pxumval ;
         Unitsname = 'um';
    case app.FiberMeasurementsUnitsDropDown.Items{3}
        COEF = pxumval*kbval ;
        Unitsname = 'kb' ; 
end


profile_table = app.UITable.Data ;

detail_cell = cell(2,2+max(profile_table.No_of_Segment));
    detail_cell{1,1} = IDX;
    detail_cell{1,2} = profile_table.No_of_Segment(IDX);
    for j = 1:length(inputtable.Fiber_Detail_Color{IDX})
        if strcmp(inputtable.Fiber_Detail_Color{IDX}(j),CH1C)
            detail_cell{1,j+2} = 'Red';
        else
            detail_cell{1,j+2} = 'Green';
        end
        try
            detail_cell{2,j+2} = inputtable.Fiber_Detail_Length{IDX}(j)*COEF;
        catch
            detail_cell{2,j+2} = inputtable.Fiber_Detail_Length(IDX)*COEF;
        end
    end
detail_table = cell2table(detail_cell);
detail_table.Properties.VariableNames{1} = 'Fiber_No';
detail_table.Properties.VariableNames{2} = 'No_of_Segment';

for i = 3:width(detail_table)
    detail_table.Properties.VariableNames{i} = ...
        ['Color_and_Length_' Unitsname '_of_Segment_',num2str(i-2)];
end


tmp = detail_table(1:2,3:end) ;
C = rows2vars(tmp) ;
app.UITable2.Data = C(:,[2,3]);
app.UITable2.RowName = [] ;
app.UITable2.ColumnName = { 'Color' , 'Length'} ;


s = uistyle ; 
s.HorizontalAlignment = 'center' ; 
addStyle(app.UITable2,s) ;