# An Adaptive Method for Camera Attribution under Complex Radial Distortion Corrections

This is the official code implementation of the paper "An Adaptive Method for Camera Attribution under Complex Radial Distortion Corrections"

## Requirements

- Install MATLAB Image Processing Toolbox
- Download the [Camera-fingerprint](https://dde.binghamton.edu/download/camera_fingerprint/)
 package and run the function compile.m in folder CameraFingerprint/Filter
 - then run ```mv CameraFingerprint/Filter/* functions/```

## Note
- a pre-compiled version of [Camera-fingerprint](https://dde.binghamton.edu/download/camera_fingerprint/) is already present in "functions/". All rights belongs to the original authors.
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

## Results of the Paper
![tables](https://github.com/AndreaMontibeller/AdaptivePRNUCameraAttribution/blob/main/tables.png?raw=true)

![ROC](https://github.com/AndreaMontibeller/AdaptivePRNUCameraAttribution/blob/main/ROC_all_new-1.png?raw=true)

## If you use this material please cite:

@inproceedings{Montibeller22, \
  title={An Adaptive Method for Camera Attribution under \
Complex Radial Distortion Corrections}, \
  author={Montibeller, Andrea and P\'erez-Gonz\'alez, Fernando}, \
  year={2022, submitted}, \
}
