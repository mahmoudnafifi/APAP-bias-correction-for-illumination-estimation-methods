# As-projective-as-possible bias correction for illumination estimation algorithms


How to use:

1- In main.m file, select the dataset from 'dataset' variable, the initial estimation method from 'ill_method' variable, and the correction method  from 'method' variable. 

You can use your own dataset and/or your own initial estimation by using dataset='other'; ill_method ='yourMethodName'; but, remember to add your method name to the switch case in projective_biasCorrection.m file. 
    
    
    Also make sure that your file contains a field with your illuminant estimation method. More information is given in main.m file.



2- Run main.m

The main procedure is performed in 'projective_biasCorrection' function which has the followings parameters:

-data: a structure that contains the following fields:

1- 'gt': Nx3 ground truth illuminant vectors

2- 'illuminant_method_name': Nx3 initial estimated illuminant vectors.

   -ill_method: a string of the illuminant method name. It should match the
   name of the filed in the 'data' struct.

-method: it can be 'P', 'APAP', or 'APAP-LUT'

-param: method parameters


Please cite the following work if this program is used:
Mahmoud Afifi, Abhijith Punnappurath, Graham Finlayson, and Michael S. Brown, As-projective-as-possible bias correction for illumination estimation algorithms, Journal of the Optical Society of America A (JOSA A), Vol. 36, No. 1, pp. 71-78, 2019
-------------------------------------------------------
