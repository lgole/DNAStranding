function Spedir = Dir_Extract(dirstring,Nidx)
% Author(s): Laurent GOLE
% Created: 01-Oct-2018
% Copyright 2020 IMCB, A*STAR.
Spedir = strsplit(dirstring,filesep) ; 
Spedir =Spedir{Nidx} ;