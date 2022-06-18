function app = save_ROIs(app)
% Author(s): Laurent GOLE, LongJie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

FiberOutput_path  = getOutput_path(app) ;
% this should save all the ROIS:
ROIs_Handle = app.UIAxes.Children(1:end-1) ;
if ~isempty(ROIs_Handle)
    RP = {ROIs_Handle.Position} ;
    RPL = {ROIs_Handle.Label} ;
else
    RP = [] ;
    RPL = [] ; 
    disp('no ROIs to save.')
    return
end
% save Fibers ROI:
save([FiberOutput_path filesep app.Label_ImageName.Text '_roi.mat'], 'RP','RPL');