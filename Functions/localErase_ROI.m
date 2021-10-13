function app = localErase_ROI(app)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

warning('off','MATLAB:polyshape:repairedBySimplify')
pause(0.05)
RECORD = [];
Norg = numel(app.UIAxes.Children)-1 ;
j = 0 ;
for i = 2:Norg
    % rank 1 seems to be the drawn ROI itself.(tmp1) hence starts at 2
    pROI = app.UIAxes.Children(i).Position ;
    are=  polyshape(app.tmp1.Position) ;
    in = inpolygon(pROI(:,1),pROI(:,2), are.Vertices(:,1), are.Vertices(:,2)) ;
    
    if sum(in)>1
        disp(i)
        tmPos = app.UIAxes.Children(i).Position ;
        if sum(~in)
            app.UIAxes.Children(i).Position = [tmPos(~in,1) tmPos(~in,2)] ;
        else
            j = j+1 ;
            RECORD{j} = i ;
        end
    end
end

if ~isempty(RECORD)
    delete(app.UIAxes.Children( [RECORD{:}]))
end