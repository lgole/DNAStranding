function updir = Dir_Up(dirstring)
% Author(s): Laurent GOLE
% Created: 01-Oct-2018
% Copyright 2020 IMCB, A*STAR.
updir = strsplit(dirstring,filesep) ; 
updir = strjoin(updir(1:end-1),filesep);