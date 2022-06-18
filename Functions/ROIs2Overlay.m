function [app,skeloverlay_no] = ROIs2Overlay(app)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

Ax = app.AX_TB.Parent ;
% CONVERT ROIS TO MASK :
ROIS = Ax.Children(end-1:-1:1) ;
app.Im_BW = zeros(size(app.Im_CH1),'logical') ;
for i = 1:numel(ROIS)
    app.Im_BW = app.Im_BW | imdilate(ROIS(i).createMask,strel('disk',1)) ;
end

OVERLAY = imoverlay_16(app.Im_RGB,app.Im_BW(:,:,1),app.AnnotColor.Color) ;
    OVERLAY = OVERLAY(end:-1:1,:,:) ;
COLORCOEF = double(intmax(class(app.Im_RGB))) ; 
% BW2skelprop = regionprops( app.Im_BW(:,:,1),'Image','PixelIdxList','Centroid','BoundingBox');


if ~isempty(app.Fibers_properties)
    textloc = zeros((numel(app.Fibers_properties)),2);
    textstr = cell((numel(app.Fibers_properties)),1);
    for j = 1:(numel(app.Fibers_properties))
        textloc(j,1:2) = [app.Fibers_properties(j).Centroid(1),size(OVERLAY,1) - app.Fibers_properties(j).Centroid(2)];
       try
        textstr{j} = num2str((app.Fibers_properties(j).Label))   ;
       catch
          disp('Fiber Analysis not done yet, overlay is empty.') 
       end
    end
    
    try
    skeloverlay_no = insertText(OVERLAY,textloc,str2double(textstr),...
        'BoxOpacity',0,'AnchorPoint','CenterTop','FontSize',22,'TextColor',[(COLORCOEF).*(app.AnnotColor.Color)]);
    catch
        disp('no fibers detected in the image');
         skeloverlay_no = OVERLAY;
    end

else
    skeloverlay_no = OVERLAY;
end