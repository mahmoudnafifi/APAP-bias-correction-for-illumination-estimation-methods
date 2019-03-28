function [H,D] = ALS(A,B)
%% Alternating Least Squares function
% This function performs alternating linear least squares to map A to B
% *Input:
%   -A: 3xN initial vectors
%   -B: 3XN reference (ground-truth) vectors
% *Output:
%   -H: 3x3 homography matrix
%   -D: NxN matrix
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

i=0;
% Solving HAD=B
D = eye(size(B,2));
for j=1:size(B,2)
    D(j,j)=(A(:,j))\(B(:,j));
end
Dprev = D;
while(1)
    i=i+1;
    %Update H
    H = B/(A*D);
    % Update D
    for j=1:size(B,2)
        D(j,j)=(H*A(:,j))\(B(:,j));
    end
    err=norm(Dprev-D,'fro');
    Dprev=D;
    
    if(err<10^(-6) || i>1000)
        break;
    end
end
