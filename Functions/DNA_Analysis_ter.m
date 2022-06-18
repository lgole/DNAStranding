function app = DNA_Analysis_ter(app,d)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

% ANALYSIS BASED ON ROIS (not Binary mask).
% app.Label_ImageName.Text

FiberOutput_path  = getOutput_path(app) ;
ch1 = app.Im_CH1 ;
ch2 = app.Im_CH2 ;

% 
% pxsize     = app.pixelsizeumperpixEditField.Value ;
% basesize   = app.basesizeEditField.Value          ;
% Red_time   = app.CH1TimeEditField.Value           ;
% Green_time = app.CH2TimeEditField.Value           ;


switch lower(app.stMarkerDropDown.Value)
    case 'idu'
        IdU_First = true;
        IdU_Color =  app.CH1_COLOR.Color ;
    case 'cldu'
        IdU_First = false;
        IdU_Color =  app.CH2_COLOR.Color ;
end
if isequal(IdU_Color,[1 0 0])
    Red_is_IdU = true;
else
    Red_is_IdU = false;
end

Red_First = ~xor(Red_is_IdU,IdU_First);

% 
% % get only the 1 Channel.
% ch1 = ch1(:,:,(mean(mean(ch1))>0)) ;
% ch2 = ch2(:,:,(mean(mean(ch2))>0)) ;
% get only the 1 Channel. updated to handle 1 channel only cases...
if  sum((mean(mean(ch1))>0))>0
    ch1 = ch1(:,:,(mean(mean(ch1))>0)) ;
else
    ch1 = ch1(:,:,1);
end
if  sum((mean(mean(ch2))>0))>0
    ch2 = ch2(:,:,(mean(mean(ch2))>0)) ;
else
    ch2 = ch2(:,:,1) ;
end






% apply mean filtering for better color determination:
HH = fspecial('average',3);
% if isequal(app.CH1_COLOR.Color, [1 0 0])
chRenhance = imfilter(ch1,HH);
chGenhance = imfilter(ch2,HH);
% else
% chRenhance = imfilter(ch2,HH);
% chGenhance = imfilter(ch1,HH);  
% end

% clean up fiber properties first:
app.Fibers_properties = [] ;

% reload the ROIs
app = load_ROIs(app) ;
% 
% % clean up fiber properties first:
% app.Fibers_properties = [] ;

% 
% % this should contains  all the currently displayed ROIS:
% ROIs_Handle = app.UIAxes.Children(end-1:-1:1) ;
ROIs_Handle = app.UIAxes.Children(1:end-1) ;


% for each ROIs ( DNA FIBERS)

   d.Indeterminate = 'off' ;   
                

   %UPON ANALYSIS Assign the Value "j" to ROI LABEL?
for j = 1:numel(ROIs_Handle)
%     j
    if ~isempty(d)
%          d = uiprogressdlg(app.UIFigure,'Title','Measuring Fibers properties...',...
%                     'Icon','DNAGIF.gif','Indeterminate','off');
         % Update progress, report current estimate
        d.Value = j/(numel(ROIs_Handle)+1);
        d.Message = ['fiber ID: ' num2str(j) '/' num2str(numel(ROIs_Handle))] ;
    
    end
    singleskelimg = ROIs_Handle(j).createMask;
    singleskelimg = imclose(singleskelimg,strel('disk',1)) ;
    % behavior is a bit weird... not sure i understand what s going on
    % here singleskelimg = bwmorph(singleskelimg,'skel',1) ;
    % THIS WHOLE PART IS TRICKY ( and not so well coded:)
    % skel_seq_lenght.m is quite over sensitive rejecting fibers that visually
    % shld be ok:
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
    [~,customized_fiber_length] = skel_sequence_length(singleskelimg);
    
    % modify the skeleton to make sure it s single line :
    if  customized_fiber_length==0
        tmp = imgaussfilt(double(singleskelimg),5) ;
        singleskelimg =  bwskel(imextendedmax(bwdist(~tmp),5)) ;
        [~,customized_fiber_length] = skel_sequence_length(singleskelimg);
    end
    % try again in case it dodnt work :
    if customized_fiber_length ==0
        singleskelimg = bwmorph(bwmorph(bwmorph(bwmorph(ROIs_Handle(j).createMask,'bridge'),'close',5),'thin',Inf),'spur',1) ;
        [~,customized_fiber_length] = skel_sequence_length(singleskelimg);
    end
    
    if customized_fiber_length ==0
        disp('Still cant get the single Fiber skel! giving up on that one!')
    end
    
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
%     if isequal(app.CH1_COLOR.Color,[1 0 0])
        skelprofile = skel_profiling_02(chRenhance,chGenhance,singleskelimg,Red_First) ;
%     elseif isequal(app.CH1_COLOR.Color,[0 1 0])
%         skelprofile = skel_profiling_02(chGenhance,chRenhance,singleskelimg,Red_First) ;
%     end    
    skelprop = regionprops(singleskelimg,'PixelIdxList','Centroid','BoundingBox','Image');
    
    FieldN = fieldnames(skelprofile) ;
    FieldP = fieldnames(skelprop) ;
     
%      app.Fibers_properties(j).Label = j;
%     ROIs_Handle(j).Label = num2str(j) ;

% OVERWRITE ROI LABEL?
ROIs_Handle(j).Label =  num2str(j) ;


%      app.Fibers_properties(j).Label = str2double(ROIs_Handle(j).Label) ;
    
    for f = 1:numel(FieldN)
        app.Fibers_properties(j).(FieldN{f}) = skelprofile.(FieldN{f}) ;
    end
    
    for f = 1:numel(FieldP)
        app.Fibers_properties(j).(FieldP{f}) = skelprop.(FieldP{f}) ;
    end
     
     app.Fibers_properties(j).Label =  str2double(ROIs_Handle(j).Label) ; 
end




if ~isempty(app.Fibers_properties)
    FIBPROP = struct2table(app.Fibers_properties,'AsArray',true) ;
else
    FIBPROP = [];
end
% SAVE  STRUCTURE AS TABLE:

if  sum(app.Im_BW(:))>0
    save([FiberOutput_path  filesep  'FiberProperties.mat'],'FIBPROP');
end