# As-projective-as-possible bias correction for illumination estimation algorithms
*[Mahmoud Afifi](https://sites.google.com/view/mafifi)*<sup>1</sup>, *[Abhijith Punnappurath](https://abhijithpunnappurath.github.io/)*<sup>1</sup>, *[Graham Finlayson](https://people.uea.ac.uk/g_finlayson)*<sup>2</sup>, and *[Michael S. Brown](http://www.cse.yorku.ca/~mbrown/)*<sup>1</sup>
<br></br><sup>1</sup>York University, Canada<br></br>
<sup>2</sup>The University of East Anglia, UK
<br></br>[Project page](http://cvil.eecs.yorku.ca/projects/public_html/APAP_bias_correction/)


![main figure](http://cvil.eecs.yorku.ca/projects/public_html/APAP_bias_correction/imgs/teaser.jpg)

How to use:

1- In main.m file, select the dataset from 'dataset' variable, the initial estimation method from 'ill_method' variable, and the correction method  from 'method' variable. 

You can use your own dataset and/or your own initial estimation by using dataset='other'; ill_method ='yourMethodName'; but, remember to add your method name to the switch case in projective_biasCorrection.m file. 
    
    
Also make sure that your file contains a field with your illuminant estimation method. More information is given in main.m file.



2- Run main.m

The main procedure is performed in 'projective_biasCorrection' function which has the followings parameters:

-`data`: a structure that contains the following fields:

1- `gt`: Nx3 ground truth illuminant vectors

2- `illuminant_method_name`: Nx3 initial estimated illuminant vectors. I.e., the variable should be named with the illuminant method name.

   -`ill_method`: a string of the illuminant method name. It should match the
   name of the filed in the `data` struct.

-method: it can be `'P'`, `'APAP'`, or `'APAP-LUT'`

-param: method parameters

#### To add your own method, please update the switch case (line 100) in projective_biasCorrection.m with your method name.

---------------------------------------------------------------------------------------------------------------------
Please cite the following work if this program is used:
Mahmoud Afifi, Abhijith Punnappurath, Graham Finlayson, and Michael S. Brown, As-projective-as-possible bias correction for illumination estimation algorithms, Journal of the Optical Society of America A (JOSA A), Vol. 36, No. 1, pp. 71-78, 2019


---------------------------------------------------------------------------------------------------------------------
### Related Research Projects
- Raw Image White Balancing:
  - [SIIE](https://github.com/mahmoudnafifi/SIIE): A sensor-independent deep learning framework for illumination estimation (BMVC 2019).
  - [C5](https://github.com/mahmoudnafifi/C5): A self-calibration method for cross-camera illuminant estimation (arXiv 2020).
- sRGB Image White Balancing:
  - [When Color Constancy Goes Wrong](https://github.com/mahmoudnafifi/WB_sRGB): The first work for white-balancing camera-rendered sRGB images (CVPR 2019).
  - [White-Balance Augmenter](https://github.com/mahmoudnafifi/WB_color_augmenter): Emulating white-balance effects for color augmentation; it improves the accuracy of image classification and image semantic segmentation methods (ICCV 2019).
  - [Color Temperature Tuning](https://github.com/mahmoudnafifi/ColorTempTuning): A camera pipeline that allows accurate post-capture white-balance editing (CIC best paper award, 2019).
  - [Interactive White Balancing](https://github.com/mahmoudnafifi/Interactive_WB_correction): Interactive sRGB image white balancing using polynomial correction mapping (CIC 2020).
  - [Deep White-Balance Editing](https://github.com/mahmoudnafifi/Deep_White_Balance): A multi-task deep learning model for post-capture white-balance editing (CVPR 2020).
- Image Enhancement:
  - [CIE XYZ Net](https://github.com/mahmoudnafifi/CIE_XYZ_NET): Image linearization for low-level computer vision tasks; e.g., denoising, deblurring, and image enhancement (arXiv 2020).
  - [Exposure Correction](https://github.com/mahmoudnafifi/Exposure_Correction): A coarse-to-fine deep learning model with adversarial training to correct badly-exposed photographs (CVPR 2021).
 - Image Manipulation:
    - [MPB](https://github.com/mahmoudnafifi/modified-Poisson-image-editing): Image blending using a two-stage Poisson blending (CVM 2016).
    - [Image Recoloring](https://github.com/mahmoudnafifi/Image_recoloring): A fully automated image recoloring with no target/reference images (Eurographics 2019).
    - [Image Relighting](https://github.com/mahmoudnafifi/image_relighting): Relighting using a uniformly-lit white-balanced version of input images (Runner-Up Award overall tracks of AIM 2020 challenge for image relighting, ECCV 2020). 
    - [HistoGAN](https://github.com/mahmoudnafifi/HistoGAN): Controlling colors of GAN-generated images based on features derived directly from color histograms (CVPR 2021). 
