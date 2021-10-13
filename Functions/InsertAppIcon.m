function  InsertAppIcon(UIfigHandle,AppName,IconName)
%This function replace the top left Icon in appdesigned UIFIGURE
%Inputs (Example) : -Uifigure handle. (app.UIFigure)
%                   -Appname, name given to the mlapp file. ('SoftwareName')
%                   -IconName. ('IconName.ico')
% Author: Laurent GOLE,IMCB,A*STAR. All Rights Reserved �, 2020.

warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame')  ;
warning('off','MATLAB:hg:JavaSetHGProperty')                        ;
warning('off','MATLAB:structOnObject')                              ;
warning('off','MATLAB:ui:javaframe:PropertyToBeRemoved') ;
pause(1)                                    ;
%determine sourcecode path:
CodePath = which(AppName)                   ;
CodePath = split(CodePath,filesep)          ;
CodePath = join(CodePath(1:end-1),filesep)  ;
CodePath = CodePath{1}                      ;

%find HTML/CSS Hidden Code
figProps            = struct(UIfigHandle)           ;
controller          = figProps.Controller           ;
controllerProps     = struct(controller)            ;
platformHost        = controllerProps.PlatformHost  ;
platformHostProps   = struct(platformHost)          ;

%replace the UIFigure Icon
win         = platformHostProps.CEF                         ;
win.Icon    = [CodePath filesep 'Icons' filesep IconName ]  ;