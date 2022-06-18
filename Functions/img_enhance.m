function [chRenhance,chGenhance] = img_enhance(ch1,ch2,Red_First)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

inputimgtype = class(ch1);
saturationpercentage = [3/100,1-0.02/100];
% satruate bottom 3% and top 0.02%, not always robust since the percentage
% is fixed,but work for most cases

switch inputimgtype
    case 'uint8'
        noofbin = 2^8;
    case 'uint16'
        noofbin = 2^16;
    otherwise
        errordlg('Input image should be uint8 or uint16.','Error')
        chRenhance = 0;
        chGenhance = 0;
        return
end

% assume that the first label has less noise so that we adjust first
% channel and match second channel to the first one
    if sum(ch1(ch1~=0))>0
        chRenhance = imadjust(ch1,stretchlim(ch1(ch1~=0),saturationpercentage));
    else
        chRenhance  = ch1   ;
    end
    chGenhance = imhistmatch(ch2,chRenhance,noofbin,'Method','polynomial');
    



% 
% if Red_First
%     if sum(ch1(ch1~=0))>0
%         chRenhance = imadjust(ch1,stretchlim(ch1(ch1~=0),saturationpercentage));
%     else
%         chRenhance  = ch1   ;
%     end
%     chGenhance = imhistmatch(ch2,chRenhance,noofbin,'Method','polynomial');
%     
% else
%     if sum(ch2(ch2~=0))>0
%         chGenhance = imadjust(ch2,stretchlim(ch2(ch2~=0),saturationpercentage));
%           chRenhance = imhistmatch(ch1,chGenhance,noofbin,'Method','polynomial');
%     else
%         chGenhance  = ch2   ;
%        chRenhance =    imadjust(ch1,stretchlim(ch1(ch1~=0),saturationpercentage));
% %           chRenhance = imhistmatch(ch1,chGenhance,noofbin,'Method','polynomial');
%     end
%   
% end


end


% TO DISPLAY HIISTOGRAM OF EACH CHANNELS
% chRenhance = imadjust(ch1,stretchlim(ch1(ch1~=0),saturationpercentage));
% chGenhance  = imhistmatch(ch2,chRenhance,noofbin,'Method','uniform');
% chGenhance1 = imadjust(ch2,stretchlim(ch2(ch2~=0),saturationpercentage));
% chGenhance2 = imhistmatch(ch2,chRenhance,noofbin,'Method','polynomial');
% figure ;
% subplot(2,5,1)
% imagesc(ch2) ; title('raw image')
% subplot(2,5,2)
% imhist(ch2) ; title('raw histogram')
%
% subplot(2,5,3)
% imagesc(chGenhance1) ; title('independant: bottom 3% and top 0.02%')
% subplot(2,5,4)
% imhist(chGenhance1) ; title(' bottom 3% and top 0.02%')
%
% subplot(2,5,6)
% imagesc(chGenhance) ; title('histmatch:  uniform ')
% subplot(2,5,7)
% imhist(chGenhance) ; title('histmatch:  uniform ')
%
% subplot(2,5,8)
% imagesc(chGenhance2) ; title('histmatch:  polynomial ')
% subplot(2,5,9)
% imhist(chGenhance2) ; title('histmatch:  polynomial ')
%
% subplot(2,5,5)
% imagesc(chRenhance) ; title('enhanced reference image')
% subplot(2,5,10)
% imhist(chRenhance) ; title('enhanced reference Histogram')