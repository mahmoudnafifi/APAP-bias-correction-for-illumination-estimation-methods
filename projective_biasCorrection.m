function [est_ill, Models, angular_error, repproduction_error, ...
    Mean_ae,Median_ae,Best25_ae,Worst25_ae,...
    Mean_rpe,Median_rpe,Best25_rpe,Worst25_rpe] =...
    projective_biasCorrection (data,ill_method, method,param)
%% projective_biasCorrection function
% This function performs the training/testing processes.
% *Input: 
%   -data: a structure that contains the following fileds:
%        1- 'gt': Nx3 ground truth illuminant vectors
%        2- 'illuminant_method_name': Nx3 initial estimated illuminant 
%        vectors.
%   -ill_method: string of the illuminant method name. It should match the
%   name of the filed in the 'data' struct.
%   -method: it can be 'P', 'APAP', or 'APAP-LUT'
%   -param: method parameters
% *Output: 
%   -est_ill: Nx3 corrected illuminant vectors
%   -Models: train models (model for each fold -- we use 3 fold validation)
%   -angular_error: Nx1 angular error between the corrected illuminant
%   vectors and ground truth vectors.
%   -repproduction_error: Nx1 reproduction error between the corrected
%   illuminant vectors and ground truth vectors.
%   -Mean_ae: mean angular error
%   -Median_ae: median angular error
%   -Best25_ae: best 25% angular error
%   -Worst25_ae: worst 25% angular error
%   -Mean_rpe: mean reproduction error
%   -Median_rpe: median reproduction error
%   -Best25_rpe: best 25% reproduction error
%   -Worst25_rpe: worst 25% reproduction error
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

try
    indices=load_folds(data.camera);
    N = max(unique(indices));
catch
    N = 3;
    L = size(data.gt,1);
    indices = crossvalind('Kfold', L, N);
end
est_ill = [];
gt_ill = [];
for fold = 1 : N 
    tr = setdiff([1:N],fold);
    training_inds = (indices == tr(1)) | (indices == tr(2));
    testing_inds = indices == fold;
    switch ill_method
        case 'gw'
            ill_data = [data.gw];
        case 'sog'
            ill_data = [data.sog];
        case 'ge_1'
            ill_data = [data.ge_1];
        case 'ge_2'
            ill_data = [data.ge_2];
        case 'pca'
            ill_data = [data.pca];    
        case 'gw_s'
            ill_data = [data.gw_s];
        case 'sog_s'
            ill_data = [data.sog_s];
        case 'ge_1_s'
            ill_data = [data.ge_1_s];
        case 'ge_2_s'
            ill_data = [data.ge_2_s];
        case 'pca_s'
            ill_data = [data.pca_s];
        case 'Bayesian'
            ill_data = [data.Bayesian];
        case 'CCNIS'
            ill_data = [data.CCNIS];
        case 'ExemplarCC'
            ill_data = [data.ExemplarCC];
%       case 'YourOwnMethod'
%           ill_data = [data.ill];
        otherwise
            error('Wrong method');
    end
    
    
    training_ill = ill_data(training_inds,:);
    gt_training_ill = data.gt(training_inds,:);
    
    testing_ill = ill_data(testing_inds,:);
    gt_testing_ill = data.gt(testing_inds,:);
    tr = 0;
    te = 0;
    if strcmpi(method,'none') ==0
        %training
        tic;
        model = training(training_ill,gt_training_ill, method, param);
        
        model.Trainingnames = data.names(training_inds);
        tr =tr + toc;
        
        %testing
        tic;
        est_ill = [est_ill; testing(testing_ill, model, method)];
        te=te+toc;
        
    else
        model=[];
        est_ill=[est_ill;testing_ill]; %no bias correction
    end
    gt_ill = [gt_ill; gt_testing_ill];
    Models(fold).model = model;
end
[angular_error, repproduction_error] = evaluate (est_ill , gt_ill);
Mean_ae=mean(angular_error);
Median_ae=median(angular_error);
Best25_ae= mean(angular_error(angular_error<=quantile(angular_error,0.25)));
Worst25_ae= mean(angular_error(angular_error>=quantile(angular_error,0.75)));

Mean_rpe=mean(repproduction_error);
Median_rpe=median(repproduction_error);
Best25_rpe= mean(repproduction_error(repproduction_error<=quantile(repproduction_error,0.25)));
Worst25_rpe= mean(repproduction_error(repproduction_error>=quantile(repproduction_error,0.75)));

end