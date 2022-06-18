function app =DNA_Table1(app)
% MAIN DNA STRANDS  TABLE:
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.


inputtable = struct2table(app.Fibers_properties,'AsArray',true);

biomarker1 = app.stMarkerDropDown.Value;
biomarker2 = app.ndMarkerDropDown.Value;

% 1st marker and it s associated color:
if isequal(app.CH1_COLOR.Color,[1 0 0])
    CH1C = 'R' ;
elseif isequal(app.CH1_COLOR.Color,[0 1 0])
    CH1C = 'G' ;
end
% 2nd marker and it s associated color:
if isequal(app.CH2_COLOR.Color,[1 0 0])
    CH2C = 'R' ;
elseif isequal(app.CH2_COLOR.Color,[0 1 0])
    CH2C = 'G' ;
end

pxumval =  app.pixelsizeumperpixEditField.Value ;
kbval = app.basesizeEditField.Value ;

Units = app.FiberMeasurementsUnitsDropDown.Value;
%   pixels
%   µm
%   kb
%   %
% depending on display Units: (not for % though)
% ADAPT ALL OUTPUT TO THE APP DISPLAY UNIT:
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
        %     case app.FiberMeasurementsUnitsDropDown.Items{4}
        %         % WARNING AS COEF IS A VECTOR HERE IT MAY CAUSE ERROR LATER , IT IS
        %         % ANYWAY NOT ADVISED TO OUTPUT TABLE IN % SO PROBABLY BEST TO
        %         % REMOVE IT and select kb by default ?
        %         %         COEF =  100./inputtable.Fiber_Length ;
        %         %         Unitsname = 'pct' ;
        %         % KB BY DEFAULT:
        %         COEF = pxumval*kbval ;
        %         Unitsname = 'kb' ;
end



profile_table = table;

profile_table.Fiber_No = [app.Fibers_properties.Label]';

profile_table.No_of_Segment = cellfun('size',inputtable.Fiber_Detail_Color,2);

profile_table.(['Fiber_Length_' Unitsname]) = inputtable.Fiber_Length.*COEF ;

profile_table.([biomarker1 '_Length_' Unitsname]) = inputtable.Red_Length.*COEF;
profile_table.([biomarker2 '_Length_' Unitsname]) = inputtable.Green_Length.*COEF;

profile_table.([biomarker1 '_' biomarker2  '_Ratio']) = inputtable.Red_Length./inputtable.Green_Length ;
profile_table.([biomarker2 '_' biomarker1  '_Ratio']) = inputtable.Green_Length./inputtable.Red_Length ;

profile_table.([biomarker1 '_Speed_' Unitsname '_per_min']) = profile_table.([biomarker1 '_Length_' Unitsname])./ app.CH1TimeEditField.Value;
profile_table.([biomarker2 '_Speed_' Unitsname '_per_min']) = profile_table.([biomarker2 '_Length_' Unitsname])./ app.CH2TimeEditField.Value;

profile_table.(['Overall_Speed_' Unitsname '_per_min']) = profile_table.(['Fiber_Length_' Unitsname])./( app.CH1TimeEditField.Value+ app.CH2TimeEditField.Value);

% I WOULD LIKE BETTER TO RENAME IT CLASS INSTEAD OF "SPECIAL PATTERN"
profile_table.Class = inputtable.Class;

for i = 1:height(profile_table)
    if any(strcmp(profile_table.Class{i},{'Bidirectional Fork','Asymmetric Fork Progression'}))
        
        
       if iscell(  inputtable.Fiber_Detail_Length) 
        profile_table.(['Bidirectional_Length_Difference_' Unitsname])(i) = abs(...
            inputtable.Fiber_Detail_Length{i}(1) - ...
            inputtable.Fiber_Detail_Length{i}(3))*COEF;
        
       else
              profile_table.(['Bidirectional_Length_Difference_' Unitsname])(i) = abs(...
            inputtable.Fiber_Detail_Length(1) - ...
            inputtable.Fiber_Detail_Length(3))*COEF;
       end
        
    else
        profile_table.(['Bidirectional_Length_Difference_' Unitsname])(i) = nan;
    end
end

if iscell(inputtable.Inter_Origin_Distance)
    tmp = cellfun(@(x) num2str(x*COEF),(inputtable.Inter_Origin_Distance),'UniformOutput',false);
    profile_table.(['Inter_Origin_Distance_' Unitsname]) = tmp;
else
    % ONLY 1 FIBER IN THE IMAGE!:
    profile_table.(['Inter_Origin_Distance_' Unitsname]) = inputtable.Inter_Origin_Distance.*COEF;
end

app.UITable.Data= profile_table ;
app.UITable.ColumnName = strrep(profile_table.Properties.VariableNames,'_',' ') ;

s = uistyle ;
s.HorizontalAlignment = 'center' ;
addStyle(app.UITable,s) ;