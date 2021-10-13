function ndir = Dir_Num(dirstring)
% Author(s): Laurent GOLE
% Created: 01-Oct-2018
% Copyright 2020 IMCB, A*STAR.
updir = strsplit(dirstring,filesep) ;
ndir = numel(updir);