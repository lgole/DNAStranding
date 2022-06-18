function [fiberimg1, fiberimg2] = fiber_detectionBEST(chR,chG)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

% get only the 1 Channel. updated to handle 1 channel only cases...
if  sum((mean(mean(chR))>0))>0
    chR = chR(:,:,(mean(mean(chR))>0)) ;
else
    chR = chR(:,:,1);
end
if  sum((mean(mean(chG))>0))>0
    chG = chG(:,:,(mean(mean(chG))>0)) ;
else
    chG = chG(:,:,1) ;
end


inputimgtype = class(chR);
switch inputimgtype
    case 'uint8'
        imgray = uint8(0.5*double(chR)+0.5*double(chG));
        scalefactor = 1;
    case 'uint16'
        imgray = uint16(0.5*double(chR)+0.5*double(chG));
        scalefactor = 257;
end

% a gaussian filtering first:
imgray = imgaussfilt(imgray,3) ;

% frangi preprocess: --> imgray1
imgray1 = double(fibermetric(imgray,'Thickness',10,'StructureSensitivity',quantile(imgray(:),0.9))) ;
tmp = (imgray1./max(imgray1(:))).* double(max(imgray(:))) ;
imgray1 = cast(tmp,class(imgray)) ;


% it seems there s always background / low intensity fibers / high
% intensity fibers hence 3 for GMM fit.
GMModel = fitgmdist(double(imgray1(:)),3,...
    'Options',statset('MaxIter',100),'Replicates',5,'Start','plus',...
    'SharedCovariance',true,'CovarianceType','diagonal','RegularizationValue',0.01);
[~,minidx] = min(GMModel.mu);
BWimage1 = imgray1>( GMModel.mu(minidx)+0.00*GMModel.Sigma) ;

GMModel = fitgmdist(double(imgray(:))/scalefactor,2,...
    'Options',statset('MaxIter',100),'Replicates',5,'Start','plus');
muval = GMModel.mu*scalefactor;
sigmaval = GMModel.Sigma*scalefactor;
[~,minidx] = min(muval);
two_sigma_th = muval(minidx)+2*sigmaval(minidx);
BWimage2 = imgray>two_sigma_th;


% some post binarization cleaning:
fiberimg1 = bwmorph(bwmorph(BWimage1,'spur'),'clean');
fiberimg1 = imdilate(fiberimg1,strel('disk',1));

% some post binarization cleaning:
fiberimg2 = bwmorph(bwmorph(BWimage2,'spur'),'clean');
fiberimg2 = imdilate(fiberimg2,strel('disk',1));

