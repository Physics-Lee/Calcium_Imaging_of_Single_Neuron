# Workflow

up-stream

* `.tif` -> `is_outlier.mat`, `.mp4`, `intensity.mat`


down-stream

* 2 `is_outlier.mat` -> `is_outlier_union.mat`

* `intensity.mat`, `is_outlier_union.mat` ->`intensity.mat`,  `intensity_volume.mat`

* 2 `intensity_volume.mat` -> figures



# How to Get the Intensity?

* How to detect outliers?

  * Tukey test of the number of bright pixels of certain binary frame. IQR_index = 1
  * Tukey test of the intensity of bright pixels of certain binary frame. IQR_index = 1
  * Tukey test of the `intensity_volume` of certain volume. IQR_index = 1
  * Tukey test of the diff or ratio. IQR_index = 3

* How to deal with outliers?: make them to be nan.



# How to Split the Soma and the Neurite?

## tune

super-parameter

* sense
* disk_r



note:

* Usually, $sense = 0.2$ is OK. In other words, you don't need to fine tune this super-parameter.
* $disk_r$ is needed to changed. You must tune it to split the soma and the neurite of the template channel. $disk_r \in \{3,4,5,6,7,8\}$



## template

Conditions for the soma template: neurite and soma are easy enough to be split.

Conditions for the neurite template

* neurite is bright enough.
* neurite and soma are easy enough to be split.

Conditions for the all template: bright enough.

In the big-gradient exp, usually

* the red channel is used as the soma template.
* the green channel is used as the neurite template.
* the green channel is used as the all template.



## halo

Use opening to remove the halo of the soma after digging out it from the original BW.
