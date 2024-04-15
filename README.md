[![Youtube](https://img.shields.io/badge/YouTube-Demo-red)](https://www.youtube.com/watch?v=4X_8FBpwh8g)

[![GitHub](https://img.shields.io/github/license/Wenlab/Machine_Label_of_Colbert)](https://github.com/Wenlab/Calcium_Imaging_of_a_Single_Neuron/blob/master/LICENSE)

# Update Log

* 2024-04-15: version 1.0.0, first release.



# Demo

The following videos are the results from a single experiment. (P.S.: `w3_ND16_2024-04-10_23-28-30` in our server). 

![Demo GIF](/README/demo.gif)

Check full videos of this experiment on YouTube.

* Original
* [Soma + Axon + Dendrite](https://www.youtube.com/watch?v=3BWrGnO12g4)
* [Soma](https://www.youtube.com/watch?v=-1cdvQVFOaY)
* [Axon + Dendrite](https://www.youtube.com/watch?v=V4snguF-bec)




# User Guide

## Workflow

`up-stream.m`

* `.tif` -> `is_outlier.mat`, `.mp4`, `intensity.mat`

`down-stream.m`

* 2 `is_outlier.mat` -> `is_outlier_union.mat`

* `intensity.mat`, `is_outlier_union.mat` ->`intensity.mat`,  `intensity_volume.mat`

* 2 `intensity_volume.mat` -> figures of red and green channel

  

## The Structure of the Data Folder

```
Data
│
├── w1
│   ├── 0_Camera-Red_VSC-10629
│   │   └── *.tif
│   └── 1_Camera-Green_VSC-09321
│       └── *.tif
│
├── w2
│   ├── 0_Camera-Red_VSC-10629
│   │   └── *.tif
│   └── 1_Camera-Green_VSC-09321
│       └── *.tif
│
├── w3
│   ├── 0_Camera-Red_VSC-10629
│   │   └── *.tif
│   └── 1_Camera-Green_VSC-09321
│       └── *.tif
...
```



## The Selection

When using `up-stream.m`, select a folder of the `w1` level.

When using `down-stream.m`, select a folder of the `Data` level.



# Principle

## How to Get the Intensity?

Answer: Use binarization.

note:

* How to detect outliers? (Don't need fine-tune)

  * Tukey test of the number of bright pixels of certain binary frame. IQR_index = 1.5
  * Tukey test of the intensity of bright pixels of certain binary frame. IQR_index = 1.5
  * Tukey test of the `intensity_volume` of certain volume. IQR_index = 3
  * Tukey test of the diff or ratio. IQR_index = 3

* How to deal with outliers?
  * make them to be nan.


## How to Split the Soma and the Neurite (Axon + Dendrite)?

Answer: Use opening.

### tune

super-parameter

* sense
* disk_r



note:

* Usually, $sense = 0.2$ is OK. In other words, you don't need to fine tune this super-parameter.
* $disk_r$ is needed to changed. You must tune it to split the soma and the neurite of the template channel. $disk_r \in \{3,4,5,6,7,8\}$



### template

Requirements

* for the soma template: the soma and the neurite are easy enough to be split.
* for the neurite template: the neurite is brighter than the other channel.
* for the all template: the soma and the neurite are brighter than the other channel.



For example, in our taxis project in 2023/11, the green channel is brighter than the red channel, so

* the red channel is used as the soma template.
* the green channel is used as the neurite template.
* the green channel is used as the all template.



### halo

Use opening to remove the halo of the soma after digging out it from the original BW.



## How to Split Worms When Having Multiple Animals?

First, we must have a template for the whole neuron, otherwise, the affect of noise will be much more severe.

I use this criteria: in certain frame, for certain worm, choose the channel which has more bright pixels!
