function LampSwitch(app,option,text)
%This function provide a smooth color changing for UILamp in app
%Inputs : -app handle
%         -option :   'on' switch lamp color to orange
%                     'off' switch lamp back to green
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

switch option
    case 'on'
        app.Lamp.Color = [1 0.647 0] ;
        app.LampText.Text = text ;
    case 'off'
        c1 = linspace(1,0,50) ;
        c2 = linspace(0.647,1,50) ;
        for i = 1:50
            app.Lamp.Color = [c1(i) c2(i) 0] ;
            drawnow
            pause(0.01)
        end
        app.LampText.Text = text;
end