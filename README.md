# Get the Intensity

steps:

* `.tif` -> `is_outlier.mat`,`.mp4`, `intensity.mat`

* 2 `is_outlier.mat` -> `is_outlier_union.mat`

* `intensity.mat`, `is_outlier_union.mat` ->`intensity.mat`,  `intensity_volume.mat`

* 2 `intensity_volume.mat` -> figure



note:

* How to detect outliers?

  * Tukey test of the number of bright pixels of certian binary frame. IQR_index = 1
  * Tukey test of the intensity of bright pixels of certian binary frame. IQR_index = 1
  * Tukey test of the `intensity_volume` of certian volume. IQR_index = 1
  * Tukey test of the diff or ratio. IQR_index = 3

* How to deal with outliers?: make them to be nan.




super-parameter

* sense threshold: 0.01, 0.1, 0.2
* IQR index



parameter

* frame per volume: 5 or 10
* volume per second: 5 or 10



# Split the Soma and the Neurite

super-parameter

* sense
* disk_r



note:

* Usually, $sense = 0.2$ is OK. In other words, you don't need to fine tune this super-parameter.
* $disk_r$ is needed to changed. You must tune it to split the soma and the neurite of the template channel. $disk_r \in \{3,4,5,6,7,8\}$
