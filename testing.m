function corr_ill = testing (est_ill, model, method)
%% testing function
% Testing a bias correction model:
% *Input: 
%   -est_ill: Nx3 initial estimation of scene illuminant vectors
%   -model: one of our models generated from 'training' function
%   -method: it can be 'P', 'APAP', or 'APAP-LUT'
% *Output: 
%   -corr_ill: Nx3 corrected illuminant vectors
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
switch method
    case 'P'
       corr_ill=  apply_corr_matrix(model.H, est_ill);
    case 'APAP'
        corr_ill = zeros(size(est_ill,1),3);
        for i=1:size(est_ill,1)
            % Obtain kernel  
            ker = exp(-comp_angular_error(est_ill(i,:),...
                model.inData)./model.sigma^2);   
            % Capping/offsetting kernel
            Wi = max(model.gamma,ker);
            %Solving HADW=BW
            [H,~]=ALS(model.inData'*diag(Wi),model.outData'*diag(Wi));
            corr_ill(i,:) = (H * est_ill(i,:)')' ;
        end
    case 'APAP-LUT'
        corr_ill = zeros(size(est_ill,1),3);
        for i=1:size(est_ill,1)
            corr_ill(i,:) = lookup_LUT_2D_bilinear(est_ill(i,:),...
                model.LUT,model.bins);
        end
end