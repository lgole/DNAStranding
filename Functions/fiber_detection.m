function fiberimg = fiber_detection(chR,chG,prefilter_method,threshold_method)
% Author(s): Longjie LI, Laurent GOLE
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
          
    case 'double'
        disp('empty image')
        fiberimg = [] ;
        return
end

% A gaussian filtering first:
imgray = imgaussfilt(imgray,3) ;


switch lower(prefilter_method)
    case 'frangi'
        imgray1 = double(fibermetric(imgray,'Thickness',10,'StructureSensitivity',quantile(imgray(:),0.9))) ;
        tmp = (imgray1./max(imgray1(:))).* double(max(imgray(:))) ;
        imgray1 = cast(tmp,class(imgray)) ;
    case 'none'
        imgray1 = imgray;
end

switch [lower(prefilter_method),lower(threshold_method)]
    case 'frangigmm'
        % it seems there s always background / low intensity fibers / high
        % intensity fibers hence 3 for GMM fit.
        GMModel = fitgmdist(double(imgray1(:)),3,...
            'Options',statset('MaxIter',100),'Replicates',5,'Start','plus',...
            'SharedCovariance',true,'CovarianceType','diagonal','RegularizationValue',0.01);
        [~,minidx] = min(GMModel.mu);
        BWimage = imgray1>( GMModel.mu(minidx)+0.00*GMModel.Sigma) ;
        
        
    case 'nonegmm' 
              GMModel = fitgmdist(double(imgray1(:))/scalefactor,2,...
            'Options',statset('MaxIter',500),'Replicates',5,'Start','plus');
        muval = GMModel.mu*scalefactor;
        sigmaval = GMModel.Sigma*scalefactor;
        [~,minidx] = min(muval);
        two_sigma_th = muval(minidx)+2*sigmaval(minidx);
        BWimage = imgray1>two_sigma_th;
   
    case 'noneotsu'
         % apply Otsu Threshold to gray image.
        BWimage = imbinarize(imgray1) ;   
        
    case 'frangiotsu'
        % apply Otsu Threshold to frangi filtered image.
        BWimage = imbinarize(imgray1) ;

        
end

% some post binryzation cleaning:
fiberimg = bwmorph(bwmorph(BWimage,'spur'),'clean');
fiberimg = imdilate(fiberimg,strel('disk',1));
end