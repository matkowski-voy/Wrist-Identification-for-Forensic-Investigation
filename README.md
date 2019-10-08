# Wrist-Identification-for-Forensic-Investigation

## Paper
Wojciech Michal Matkowski, Frodo Kin Sun Chan and Adams Wai Kin Kong. A Study on Wrist Identification for Forensic Investigation. Image and Vision Computing, vol. 88, August 2019, pp 96-112. https://doi.org/10.1016/j.imavis.2019.05.005

Paper can be found now on ScienceDirect [here](https://www.sciencedirect.com/science/article/pii/S0262885619300733)\
Preprint can be found on arXiv soon

## Dataset
### How to acquire the dataset?
To acquire the NTU-Wrist-Image-Database-v1 dataset (which was used in the paper), download and fill in the "Data Release Agreement.pdf" file. Print the agreement and sign on page 2. Scan the signed copy and send back to matk0001@e.ntu.edu.sg, xpxu@ntu.edu.sg or adamskong@ntu.edu.sg with title "Application for NTU-Wrist-Image-Database-v1 dataset". A download link to the corresponding dataset will be send to you once after we receive the signed agreement file.

### Image examples
![alt text](https://github.com/matkowski-voy/Wrist-Identification-for-Forensic-Investigation/blob/master/originalImages.png)\
Examples of original wrist images (note: in folder SEToriginalWristImages all images are already flipped). 

![alt text](https://github.com/matkowski-voy/Wrist-Identification-for-Forensic-Investigation/blob/master/segmentedImages.png)
Examples of segmented and flipped wrist images (in folder SETsegmentedWristImages). 

![alt text](https://github.com/matkowski-voy/Wrist-Identification-for-Forensic-Investigation/blob/master/segmentedROIImages.png)
Examples of segmented, flipped and aligned ROI wrist images (in folder SETsegmentedAlignedWristImages). 

## Code

### Segmentation
- download pre-trained ensemble of decision trees superpixel skin classifiers [here](https://www.dropbox.com/s/zjkgms09zcf9eik/classifiersTrees.zip?dl=0)
- unpack downloaded classfiers and put them into classifiersTrees folder 
- in folder segmentation run maskDoSegmentation.m
- the results are saved in results folder if (write2File = true)\
NOTE: you can also visualize some steps if (plotFig = true)

## Questions
If you have any questions about the paper please email me on matk0001@e.ntu.edu.sg or maskotky@gmail.com
"Data Release Agreement.pdf" coming soon
