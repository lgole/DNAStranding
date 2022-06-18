function out=switchColors(im,order)
% Author(s): Laurent GOLE, Longjie LI
% Created: 01-Oct-2020
% Copyright 2020 IMCB, A*STAR.

switch (order(1))
    case 'r'
        first=1;
    case 'g'
        first=2;
    case 'b'
        first=3;
end
switch (order(2))
    case 'r'
        second=1;
    case 'g'
        second=2;
    case 'b'
        second=3;
end
switch (order(3))
    case 'r'
        third=1;
    case 'g'
        third=2;
    case 'b'
        third=3;
end
out=zeros(size(im),'like',im);
out(:,:,1)=im(:,:,first);
out(:,:,2)=im(:,:,second);
out(:,:,3)=im(:,:,third);