The results of these methods were taken from http://colorconstancy.com/



The methods are: 

1- Bayesian, ref: Bayesian color constancy revisited 


2- CCNIS, ref: Color Constancy using Natural Image Statistics


3- ExemplarCC, ref: Exemplar-Based Color Constancy and Multiple Illumination


4- AlexNetSVR (AlexNet+SVR), ref: Color Constancy Using CNNs 


5- DeepCNN (CNN fine-tuned), ref: Color Constancy Using CNNs 



data_other_methods.mat contains the following fields:

1- names: {1×568 cell}

2- Bayesian: [568×3 double]

3- gt: [568×3 double] (the given ground-truth in colorconstancy.com)

4- gt2: [568×3 double] (our ground-truth)

5- AlexNetSVR: [568×3 double]

6- CCNIS: [568×3 double]
7
-DeepCNN: [568×3 double]

8-ExemplarCC: [568×3 double]