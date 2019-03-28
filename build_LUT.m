function LUT=build_LUT(LUTsize,sigma,gamma,getrain,gttrain)
%% Build lookup table function
% This function constructs the lookup table
% *Input:
%   -LUTsize: number of bins of the lookup table (scalar)
%   -sigma: scalar parameter (Eq. 3 in the paper)
%   -gamma: offset parameter [0-1]
%   -getrain: Nx3 initial estimated vectors
%   -gttrain: Nx3 ground truth vectors
% *Output:
%   -LUT: the constructed lookup table 
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

getrain_proj=getrain(:,1:2)./sum(getrain,2);
LatticeEndPoints=linspace(0,1,LUTsize+1);
LUT=cell(length(LatticeEndPoints),length(LatticeEndPoints));
for p=1:length(LatticeEndPoints)
    for q=1:length(LatticeEndPoints)
        getest=[LatticeEndPoints(p) LatticeEndPoints(q)];
        % Obtain kernel
        myker = exp(-comp_angular_error([getest ones(size(getest,1),1)],...
            [getrain_proj  ones(size(getrain_proj,1),1)])./sigma^2);
        % Capping/offsetting kernel
        Wi = max(gamma,myker);
        [H,~]=ALS(getrain'*diag(Wi),gttrain'*diag(Wi));
        LUT{p,q} = H;
    end
end

