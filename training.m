function model = training(training_ill,gt_training_ill, method, param)
%% training function
% %Training a bias correction method:
% *Input: 
%   -training_ill: Nx3 initial estimation of scene illuminant vectors
%   -gt_training_ill: Nx3 ground truth illuminant vectors
%   -method: it can be 'P', 'APAP', or 'APAP-LUT'
%   -param: method parameters
% *Output: 
%   -model: trained bias correction model
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
if nargin == 3
    param=[];
end
switch method
    case 'P'
        [H,~]=ALS(training_ill',gt_training_ill');
        model.H = H;
    case 'APAP'
        if isempty(param)==1
            model.sigma=3;
            model.gamma=0.065; % if gamma = 1, then APAP equal to global 
            %projection
        else
            model.sigma=param.sigma;
            model.gamma=param.gamma;
        end
        model.inData = training_ill;
        model.outData = gt_training_ill;
        
    case 'APAP-LUT'
        if isempty(param)==1
            model.sigma=0.3;
            model.gamma=0.0275; % if gamma = 1, then APAP equal to global 
            %projection
            model.bins=16; %default LUT bins
        else
            model.sigma=param.sigma;
            model.gamma=param.gamma;
            model.bins =param.bins;
        end
        tic
        model.LUT=build_LUT(model.bins,model.sigma,model.gamma,...
            training_ill,gt_training_ill);
        t=toc;
        fprintf('LUT was built in %f seconds\n',t);
        
end
end