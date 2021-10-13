function app = ROIs2BW(app)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

Ax = app.AX_TB.Parent ;
% CONVERT ROIS TO MASK :
ROIS = Ax.Children(1:end-1) ;
app.Im_BW = zeros(size(app.Im_CH1),'logical') ;
for i = 1:numel(ROIS)
    app.Im_BW = app.Im_BW | imdilate(ROIS(i).createMask,strel('disk',1)) ;
end