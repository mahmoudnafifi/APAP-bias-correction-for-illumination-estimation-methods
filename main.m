%% This code is the main code to train and test our correction methods. 
%
%  Please, select the dataset from 'dataset' variable, the initial 
%  estimation method from 'ill_method' variable, and the correction method
%  from 'method' variable. You can use your own dataset and/or your own
%  initial estimation by using dataset='other'; 
%  ill_method ='yourMethodName'; But, remember to add your method name to
%  the switch case in projective_biasCorrection.m file. Also make sure that
%  your file contains a field with your illuminant estimation method. More 
%  information is given below.
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

clc
clear

dataset = 'SHI'; %NUS, SHI, INTEL, or other*
%* for other datasets, use dataset = 'other'; and please provide in the 
% 'ill_estimation' directory a .mat file named data_xyz.mat that contains 
% 'data' struct with fields:
% - names: {1×N cell} -> which contains N image names 
% - gt: [N×3 double] -> which contains N ground-truth illuminant vectors
% - ill_method: [Nx3 double] -> which contains N initial illuminant 
% estimation using an illuminant estimation method specified in ill_method 
% variable (see below), or you can use your own ill_method, such that the 
% ill_method below has the same name of the field.

ill_method = 'gw_s'; %gw, ge_1, ge_2, sog, pca, gw_s, ge_1_s, ... (s) for 
%the downsampled images. gw = grayworld, ge = gray-edges, sog = 
%shades-of-gray.
%If you want to add a new method, modify the switch case in
%projective_biasCorrection.m (lines 100-101).

method = 'APAP'; %none, P, APAP: , APAP-LUT
%none: no bias correction applied
%P: global projection
%APAP: As-projective-as-possible
%APAP-LUT: As-projective-as-possible + lookup table

% APAP parameters
if strcmp(method,'APAP') == 1 || strcmp(method,'APAP-LUT') == 1
    param.sigma=3;
    param.gamma=0.065; % if gamma = 1, then APAP equal to global projection
    param.bins = 16; %for APAP-LUT
else
    param =[];
end

if strcmpi(dataset,'SHI') == 1
    cameras = {'Canon1d', 'Canon5d'}; %Shi cameras
elseif strcmpi(dataset,'NUS') == 1
    cameras = {'Canon1DsMkIII','Canon600D','FujifilmXM1',...
        'NikonD5200','OlympusEPL6',...
        'PanasonicGX1','SamsungNX2000','SonyA57'}; %8-Cameras NUS
elseif strcmpi(dataset,'INTEL') == 1 %INTEL-TUT
    cameras = {'Canon_5DSR_field', 'Canon_5DSR_field2', ...
        'Canon_5DSR_lab_printouts', 'Canon_5DSR_lab_realscene',...
        'Mobile_field_With_BLC_CSC',...
        'Mobile_lab_printouts_With_BLC_CSC',...
        'Mobile_lab_realscene_With_BLC_CSC',...
        'Mobile_field_Without_BLC_CSC',...
        'Mobile_lab_printouts_Without_BLC_CSC',...
        'Mobile_lab_realscene_Without_BLC_CSC',...
        'Nikon_D810_field','Nikon_D810_lab_printouts',...
        'Nikon_D810_lab_realscene'};
elseif strcmpi(dataset,'other') == 1 %Other datasets
    cameras = {'xyz'};
else
    error('Wrong dataset');
end


ae = []; %angular error will be stored here
rpe =[]; %reproduction error will be stored here (it did not be included in
%the paper results)
ill_est = []; %ill estimation after applying the correction method in 
%'method' variable
names=[]; %image names
gt=[]; %ground truth will be loaded here

for c = 1 : length(cameras)
    if strcmpi(dataset,'INTEL') && (c == 1 || c == 5 || c== 8 || c==11)
        switch c
            case 1
                CAMERA = 'Canon 5DSR';
            case 5
                CAMERA = 'Mobile - with BLC CSC';
            case 8
                CAMERA = 'Mobile - without BLC CSC';
            case 11
                CAMERA = 'Nikon D810';
        end
        tempae=[];
        temprpe=[];
    end
    
    camera= cameras{c};
    fprintf('-------------------------------------\n');
    fprintf('Camera: %s\n',camera);
    
    
    load(fullfile('ill_estimation',sprintf('data_%s.mat',camera)));
    data.camera = camera;
    names=[names;data.names'];
    [ill_est_, models, ae_, rpe_,Mean_ae,Median_ae,Best25_ae,Worst25_ae,...
        Mean_rpe,Median_rpe,Best25_rpe,Worst25_rpe] = ...
        projective_biasCorrection (data,ill_method, method,param);
    if strcmpi(method,'none')==0
        if exist('models','dir')==0
            mkdir('models');
        end
        save(fullfile('models',sprintf('%s_%s_%s_models.mat',...
            camera,ill_method,method)),'models','-v7.3');
    end
    
    
    fprintf('Angular error:\n');
    fprintf('Mean= %f - Median= %f - Best 25%s= %f - Worst 25%s= %f\n',...
        Mean_ae, Median_ae, '%',Best25_ae,'%',Worst25_ae);
    
    fprintf('Reproduction error:\n');
    fprintf('Mean= %f - Median= %f - Best 25%s= %f - Worst 25%s= %f\n',...
        Mean_rpe, Median_rpe, '%',Best25_rpe,'%',Worst25_rpe);
    
    ae = [ae; ae_];
    rpe = [rpe;rpe_];
    ill_est= [ill_est; ill_est_];
    if strcmpi(dataset,'INTEL')
        tempae=[tempae; ae_];
        temprpe = [temprpe; rpe_];
        if c+1 == 5 || c+1 == 8 || c+1 ==11 || c == length(cameras)
            fprintf('Camera: %s\n',CAMERA);
            fprintf('Angular error:\n');
            Meanpc_ae=mean(tempae);
            Medianpc_ae=median(tempae);
            Best25pc_ae= mean(tempae(tempae<=quantile(tempae,0.25)));
            Worst25pc_ae= mean(tempae(tempae>=quantile(tempae,0.75)));
            
            fprintf('Mean= %f - Median= %f - Best 25%s= %f - Worst 25%s= %f\n',...
                Meanpc_ae, Medianpc_ae, '%',Best25pc_ae,'%',Worst25pc_ae);
            
            fprintf('Reproduction error:\n');
            Meanpc_rpe=mean(temprpe);
            Medianpc_rpe=median(temprpe);
            Best25pc_rpe= mean(temprpe(temprpe<=quantile(temprpe,0.25)));
            Worst25pc_rpe= mean(temprpe(temprpe>=quantile(temprpe,0.75)));
            
            fprintf('Mean= %f - Median= %f - Best 25%s= %f - Worst 25%s= %f\n',...
                Meanpc_rpe, Medianpc_rpe, '%',Best25pc_rpe,'%',...
                Worst25pc_rpe);
            
        end
        
    end
end

fprintf('-------------------------------------\n');
fprintf('Final Report of %s dataset:\n',dataset);
Mean=mean(ae);
Median=median(ae);
Best25= mean(ae(ae<=quantile(ae,0.25)));
Worst25= mean(ae(ae>=quantile(ae,0.75)));

Mean_r=mean(rpe);
Median_r=median(rpe);
Best25_r= mean(rpe(rpe<=quantile(rpe,0.25)));
Worst25_r= mean(rpe(rpe>=quantile(rpe,0.75)));


fprintf('Angular error \nMean= %.2f - Median= %.2f - Best 25%s= %.2f - Worst 25%s= %.2f\n',...
    Mean, Median, '%',Best25,'%',Worst25);


fprintf('Reproduction error \nMean= %.2f - Median= %.2f - Best 25%s= %.2f - Worst 25%s= %.2f\n',...
    Mean_r, Median_r, '%',Best25_r,'%',Worst25_r);


