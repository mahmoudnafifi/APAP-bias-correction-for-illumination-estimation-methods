function corr = apply_corr_matrix(H,est)
%% Correction function
% This function applies the correction matrix H to the initial estimated
% vectors
% *Input:
%   -H: 3x3 homography matrix
%   -est: Nx3 initial estimated illuminant vectors
% *Output:
%   -corr: Nx3 corrected illuminant vectors
%
% Copyright (c) 2019 Mahmoud Afifi, Abhijith Punnappurath, 
% Graham Finlayson, and  Michael S. Brown
% EECS, York University, Canada
% School of Computing Sciences, The University of East Anglia, UK
%
% Permission is hereby granted, free of charge, to any person obtaining
% a copy of this software and associated documentation files (the
% "Software"), to deal in the Software with restriction for its use for
% research purpose only, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.
%
% Please cite the following work if this program is used:
% Mahmoud Afifi, Abhijith Punnappurath, Graham Finlayson, and
% Michael S. Brown, As-projective-as-possible bias correction for
% illumination estimation algorithms, Journal of the Optical Society of
% America A (JOSA A), Vol. 36, No. 1, pp. 71-78, 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

corr = (H * est')' ;
    