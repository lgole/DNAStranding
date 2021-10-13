function [CH1, CH2, CH3, imRGBenh, imMask] = Read_Image(image_path,app)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

% Read images  from Input Folder: ( ome.tiff typically): ( from channel)
IDX1 = find(contains(app.CH1_DropDown.Items ,   app.CH1_DropDown.Value));
IDX2 = find(contains(app.CH2_DropDown.Items ,   app.CH2_DropDown.Value));

% so far read first and second channel as it is in the RGB tiff image:
ReadStatus = [0, 0, 0] ;
try
    imch1 = imread(image_path,IDX1);
    ReadStatus(1) = 1 ;
catch
    ReadStatus(1) = 0  ;
end

try
    imch2 = imread(image_path,IDX2);
    ReadStatus(2) = 1 ;
catch
    ReadStatus(2) = 0  ;
end

try
    % in case a Blue channel does exist?
    imchB = imread(image_path,3);
    ReadStatus(3) = 1  ;
catch
    ReadStatus(3) = 0  ;
end

% this should never happen:
if sum(ReadStatus)==0
    disp(' The image appear to be empty?')
    CH1 = 0 ; CH2 = 0 ;
    imRGBenh = 0 ;
    imMask = 0 ;
    return
elseif sum(ReadStatus) == 3
    disp('All channels exists')
end

if (ReadStatus(3)==0 && ReadStatus(1)==1)
    imchB = zeros(size(imch1),'like',imch1) ;
    CH3 = imchB ;
elseif (ReadStatus(3)==0 && ReadStatus(2)==1)
    imchB = zeros(size(imch2),'like',imch2) ;
    CH3 = imchB ;
end

if (ReadStatus(2)==0 && ReadStatus(1)==1)
    imch2 = zeros(size(imch1),'like',imch1) ;
    CH2 = imch2 ;
elseif (ReadStatus(1)==0 && ReadStatus(2)==1)
    imch1 = zeros(size(imch2),'like',imch2) ;
    CH1 = imch1 ;
end


if isequal(app.CH1_COLOR.Color,[0 1 0])% Green
    IDX = 0 ;
elseif isequal(app.CH1_COLOR.Color,[1 0 0]) % Red
    IDX = 1 ;
end

% IMPORTANT REVERSE Y AXIS FOR BETTER DISPLAY IN APP AND CONSITENCY WITH
% REAL IMAGE:
imch1 = imch1(end:-1:1,:,:) ;
imch2 = imch2(end:-1:1,:,:) ;
imchB = imchB(end:-1:1,:,:) ;

%IDX indicates which is first
[chRenh,chGenh] = img_enhance(imch1,imch2,IDX) ;

switch IDX
    case 0
        if strcmp(app.ndMarkerDropDown.Value,'None')
            chGenh = zeros(size(chRenh),'like',chRenh) ;
        end
        imRGBenh = cat(3,chGenh,chRenh, imchB);
        CH1 = imRGBenh  ;
        CH1(:,:,1) = 0 ;
        CH2 =  imRGBenh ;
        CH2(:,:,2) = 0  ;
        
    case 1
        %         imRGBenh = cat(3,chRenh,chGenh, imchB);
        if strcmp(app.ndMarkerDropDown.Value,'None')
            chGenh = zeros(size(chRenh),'like',chRenh) ;
        end
        imRGBenh = cat(3,chRenh,chGenh, imchB);
        CH1 = imRGBenh  ;
        CH1(:,:,2) = 0 ;
        CH2 =  imRGBenh ;
        CH2(:,:,1) = 0  ;
end

if ~isempty(imchB)
    CH1(:,:,3) = 0 ;
    CH2(:,:,3) = 0 ;
    CH3 =  imRGBenh  ;
    CH3(:,:,1) = 0 ;
    CH3(:,:,2) = 0  ;
    %     CH3 = CH3 ;
end





% CH1 Cannot be Empty!:
 if ~sum(CH1(:))
%      disp('aefwef')
     uialert(app.UIFigure,'The 1st Biomarker cannot be empty!','Settings or Input Error')
       imMask = zeros(size(imch1),  'logical') ; 
       
return
 end



app.CurrentFile = app.ListofimagesListBox.Value ;
FiberOutput_path  = getOutput_path(app) ;
Fname = strrep(Dir_Extract(app.ListofimagesListBox.Value,Dir_Num(app.ListofimagesListBox.Value)),app.FileFormat,['_BW' app.FileFormat]);

% ADD  AN AUTOLOAD OPTION SO THAT WE CAN DISABLE  IT ALSO
if exist([FiberOutput_path filesep Fname],'file')==2
    imMask = imread([FiberOutput_path filesep Fname]) ;
else
    imMask = zeros(size(imch1),  'logical') ;
end

% try to autoload the Table as well if it exists:
if exist([FiberOutput_path filesep 'FiberProperties.mat'],'file')==2
    try
        tmp =   load([FiberOutput_path filesep 'FiberProperties.mat']) ;
        FIBPROP = tmp.FIBPROP ;
        app.Fibers_properties = [] ;
        app.Fibers_properties = table2struct(FIBPROP) ;
        app =DNA_Table1(app);
    catch
        % if version are different loading table will fail.
    end
end



figure( app.UIFigure)

