function output = lookup_LUT_2D_bilinear(getest,LUT,LUTsize)
%% Bilinaer interpolation using a lookup table
% This function returns the corrected illuminant vectors based on our
% lookup table.
% *Input:
%   -getest: estimated illuminant vector (1x3)
%   -LUT: Our lookup table 
%   -LUTsize: number of bins of our LUT (scalar)
% *Output:
%   -output: corrected illuminant vector (1x3)
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

getestdiv=getest(1,1:2)./sum(getest(1,1:3));
thresh=10^(-6);
LatticeEndPoints=linspace(0,1,LUTsize+1);
if(getest(1)==1), getest(1)=getest(1)-thresh; end
if(getest(1)==0), getest(1)=getest(1)+thresh; end
if(getest(2)==1), getest(2)=getest(2)-thresh; end
if(getest(2)==0), getest(2)=getest(2)+thresh; end

p=sum(getestdiv(1)>=LatticeEndPoints);
q=sum(getestdiv(2)>=LatticeEndPoints);

% bilinear interpolation
H_x2_y2 = LUT{p+1,q+1};
H_x1_y1 = LUT{p,q};
H_x2_y1 = LUT{p+1,q};
H_x1_y2 = LUT{p,q+1};

x2=LatticeEndPoints(p+1);
y2=LatticeEndPoints(q+1);
x1=LatticeEndPoints(p);
y1=LatticeEndPoints(q);

x=getestdiv(1);
y=getestdiv(2);

funcmat = [ apply_corr_matrix(H_x1_y1,getest), apply_corr_matrix(H_x1_y2,getest) ;
           apply_corr_matrix(H_x2_y1,getest), apply_corr_matrix(H_x2_y2,getest) ];
leftmat = [x2-x x-x1];
rightmat = [y2-y y-y1];
const = 1/((x2-x1)*(y2-y1));

output1 = const*leftmat*[funcmat(:,1) funcmat(:,4)]*rightmat';
output2 = const*leftmat*[funcmat(:,2) funcmat(:,5)]*rightmat';
output3 = const*leftmat*[funcmat(:,3) funcmat(:,6)]*rightmat';

output=[output1 output2 output3];