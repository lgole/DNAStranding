function FiberOutput_path  = getOutput_path(app)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

app.Output_Path =   app.OutputpathEditField.Value ;
EXTRA =  strrep(app.CurrentFile,[app.Input_Path filesep],'');
if ~isempty(EXTRA)
    EXTRA2 = strrep(Dir_Extract(EXTRA,Dir_Num(EXTRA)),app.FileFormat,'') ;
else
    FiberOutput_path = [] ;
    return
end
EXTRA = Dir_Up(EXTRA) ;

if ~isempty(EXTRA)
    FiberOutput_path = [app.Output_Path  filesep EXTRA filesep EXTRA2] ;
    if ~exist(FiberOutput_path,'dir')
        mkdir([app.Output_Path  filesep EXTRA filesep EXTRA2])
    end
else
    FiberOutput_path = [app.Output_Path  filesep EXTRA2] ;
    if ~exist(FiberOutput_path,'dir')
        mkdir([app.Output_Path  filesep EXTRA2])
    end
end