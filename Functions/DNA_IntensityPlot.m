function app =  DNA_IntensityPlot(app,j)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

N = length(app.Fibers_properties(j).Rint) ;
Rintensity  =   app.Fibers_properties(j).Rint ;
Gintensity  =   app.Fibers_properties(j).Gint;
color_detec =   app.Fibers_properties(j).Color_detec;

Rintensity_smooth =     app.Fibers_properties(j).Rint_smooth ;
Gintensity_smooth =    app.Fibers_properties(j).Gint_smooth ;


% SET PLOT COLOR: 
% 1st marker and it s associated color:
if isequal(app.CH1_COLOR.Color,[1 0 0])
    CH1C = 'r' ;
elseif isequal(app.CH1_COLOR.Color,[0 1 0])
    CH1C = 'g' ;
end
% 2nd marker and it s associated color:
if isequal(app.CH2_COLOR.Color,[1 0 0])
    CH2C = 'r' ;
elseif isequal(app.CH2_COLOR.Color,[0 1 0])
    CH2C = 'g' ;
end

pxumval =  app.pixelsizeumperpixEditField.Value ;
kbval = app.basesizeEditField.Value ;
Units = app.FiberMeasurementsUnitsDropDown.Value;

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
    case app.FiberMeasurementsUnitsDropDown.Items{4}
        % WARNING AS COEF IS A VECTOR HERE IT MAY CAUSE ERROR LATER , IT IS
        % ANYWAY NOT ADVISED TO OUTPUT TABLE IN % SO PROBABLY BEST TO
        % REMOVE IT and select kb by default ?
        %         COEF =  100./inputtable.Fiber_Length ;
        %         Unitsname = 'pct' ;
        % KB BY DEFAULT: 
        COEF = pxumval*kbval ;
        Unitsname = 'kb' ;
end






plot(app.UIAxes3, (1:N).*COEF,Rintensity,[CH1C '.'])
hold(app.UIAxes3,'on')
plot(app.UIAxes3,(1:N).*COEF,Rintensity_smooth,[CH1C '-'])
plot(app.UIAxes3,(1:N).*COEF,Gintensity,[CH2C '.'])
plot(app.UIAxes3,(1:N).*COEF,Gintensity_smooth,[CH2C '-'])
hold(app.UIAxes3,'off')
title(app.UIAxes3,'Smoothed Intensity')
xlabel(app.UIAxes3,['Position along Fiber ' '(' Unitsname ')'])
ylabel(app.UIAxes3,'Intensity')
xlim(app.UIAxes3,[0 N].*COEF)

BB = app.Fibers_properties(j).BoundingBox ;
ImC =  imcrop((app.Im_RGB),[BB(1),BB(2),BB(3),BB(4)]+[-5 -5 10 10])  ;

imagesc(app.UIAxes2,ImC)
app.UIAxes2.YDir = 'normal' ;
axis(app.UIAxes2, 'equal');
axis(app.UIAxes2, 'off') ;

imagesc(app.UIAxes4,color_detec)
app.UIAxes4.YDir = 'normal' ;
axis(app.UIAxes4, 'equal');
axis(app.UIAxes4, 'off') ;
drawnow

%  LINK  FIBER  IN FOV  WITH  RECTANGLE  ROI  IN MAIN FIGURE :
delete(findall(allchild(app.AX_TB.Parent),'Tag','TmpRectangle'))
BB = app.Fibers_properties(j).BoundingBox ;
h = drawrectangle(app.AX_TB.Parent,'Position',[BB(1) BB(2) BB(3) BB(4)]+[-5 -5 10 10],...
    'Color','w','InteractionsAllowed','none','HandleVisibility','off',...
    'FaceAlpha',0,'LineWidth',2,'StripeColor','k');
h.Tag = 'TmpRectangle' ;
drawnow
