# An Adaptive Method for Camera Attribution under Complex Radial Distortion Corrections

This is the official code implementation of the paper ["An Adaptive Method for Camera Attribution under Complex Radial Distortion Corrections"](https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=10265255)

Forensic image source attribution aims at deciding whether a query
image was taken by a specific camera. While various algorithms
leveraging forensic traces have been proposed, the most effective
techniques rely on Photo Response Non-Uniformity (PRNU), a pattern introduced by camera sensors during the image acquisition
process. In recent years, advances in image acquisition and processing technologies in modern devices have been found to impact
the performance of PRNU, seemingly challenging its uniqueness.
In this paper, we build upon recent discoveries of leaks in PRNU
uniqueness, focusing on the dataset recently published by Iuliani
et al. which has been instrumental in identifying numerous issues
related to source attribution. Specifically, we analyze the effects in
terms of false positive of visible watermarks applied to Xiaomi Mi 9
images, and reveal artifacts in the magnitude of the Discrete Fourier
Transform of Samsung A50 images, indicative of the absence of
non-unique artifacts. Furthermore, we demonstrate how several
false positive cases are attributed to mislabeled devices. Finally, we
show that a number of false negatives from the dataset are traceable
to radially corrected images, and to images processed by third-party
software that had not been previously noticed.

## Requirements

- Install MATLAB Image Processing Toolbox
- Download the [Camera-fingerprint](https://dde.binghamton.edu/download/camera_fingerprint/)
 package and run the function compile.m in folder CameraFingerprint/Filter 
 - 5G of RAM
 ## Setup:
 - Download the Camera Fingerprints we used in our paper from [here](https://drive.google.com/file/d/1wpRwT7mthgPChJh9o4rkIwgbswVC5VOt/view?usp=sharing), unzip "CAMERA_FINGERPRINTS.zip" and move them into ```PRNU_FILES/```


 Move all the functions of [Camera-fingerprint](https://dde.binghamton.edu/download/camera_fingerprint/) in ```functions/``` :
 - ```mv CameraFingerprint/Filter/* functions/``` 
 - ```mv CameraFingerprint/Functions/* functions/```
 - ```mv CameraFingerprint/*.m functions/``` 
 - enter in ```functions/``` and run in MATLAB ```compile.m```
 ### Important for Linux Users
 - if you are on Linux you may face problems due to unsupported C compilers in MATLAB. Send a mail to [andrea.montibeller@unitn.it](andrea.montibeller@unitn.it) if you need a pre-compiled version of these C / C++ files or contact the authors of [Camera-fingerprint](https://dde.binghamton.edu/download/camera_fingerprint/).
 
 


## Note
<!-- - a pre-compiled version of [Camera-fingerprint](https://dde.binghamton.edu/download/camera_fingerprint/) is already present in "functions/". All rights belongs to the original authors. -->
- a set of test images are included in ```test-images/``` and the respective Camera Fingerprint can be found in ```PRNU_FILES/```
- a subset of the images we used to test our code on out-camera correction can be downloaded [here](https://drive.google.com/drive/folders/1dvNodEo5LI-gWeLvnh47-bSMGnq8wXyu?usp=sharing). We couldn't include all the images for a matter of privacy.

## Test

- run ```main.m``` to test our code on some of our test image. ```main.m``` computes the PCE and CPCE value both for the H1 and H0 hyphothesis.
- change the paths of ```Fingerprint``` and ```im``` to test our code on your data.

## Test Specific variants of our method
Changing the parameters ```transf_idx``` and ```flag_direct``` of the functions ```functions/ADAPTIVE_*.m``` it is possible to test specific variants of our code.

- ID, Lin: use ```ADAPTIVE_Inv_and_Dir.m``` + ```transf_idx=6``` and ```flag_direct=0```
- DI, Lin: use ```ADAPTIVE_Inv_and_Dir.m``` +```transf_idx=7``` and ```flag_direct=1```
- ID, Cub: use ```ADAPTIVE_Inv_and_Dir.m``` +```transf_idx=5``` and ```flag_direct=0```
- DI, Cub: use ```ADAPTIVE_Inv_and_Dir.m``` +```transf_idx=4``` and ```flag_direct=1```
- Inv, Cub: use ```ADAPTIVE_Inv_or_Dir.m``` +```transf_idx=5``` and ```flag_direct=0```
- Dir, Cub: use ```ADAPTIVE_Inv_or_Dir.m``` +```transf_idx=4``` and ```flag_direct=1```
- Inv, Lin: use ```ADAPTIVE_Inv_or_Dir.m``` +```transf_idx=6``` and ```flag_direct=0```
- Dir, Lin: use ```ADAPTIVE_Inv_or_Dir.m``` +```transf_idx=7``` and ```flag_direct=1```

## Results of the Paper and its Tech Repo

Check [An Adaptive Method for Camera Attribution under Complex Radial Distortion Corrections](https://ieeexplore.ieee.org/abstract/document/10265255) and [Technical Report Additional Material for “An Adaptive Method for Camera Attribution under Complex Radial Distortion Corrections”](https://www.researchgate.net/publication/362251662_Technical_Report_Additional_Material_for_An_Adaptive_Method_for_Camera_Attribution_under_Complex_Radial_Distortion_Corrections)

![tables](https://github.com/AMontiB/AdaptivePRNUCameraAttribution/blob/main/images/tables.png?raw=true)

![ROC](https://github.com/AMontiB/AdaptivePRNUCameraAttribution/blob/main/images/ROC_all_new-1.png?raw=true)

## If you use this material please cite:


@ARTICLE{10265255, \
  author={Montibeller, Andrea and Pérez-González, Fernando}, \
  journal={IEEE Transactions on Information Forensics and Security}, \
  title={An Adaptive Method for Camera Attribution Under Complex Radial Distortion Corrections}, \
  year={2024}, \
  volume={19}, \
  number={}, \
  pages={385-400}, \
  keywords={Distortion;Cameras;Fingerprint recognition;Adaptation models;Smart phones;Lenses;Forensics;Image forensics;source attribution;PRNU;photo response non-uniformity;radial correction;distortion correction;PCE;adaptive processing}, \
  doi={10.1109/TIFS.2023.3318933}}

