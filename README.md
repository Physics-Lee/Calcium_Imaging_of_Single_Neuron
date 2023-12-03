steps:

* `.tif` -> `is_outlier.mat`,`.mp4`, `intensity.mat`

* 2 `is_outlier.mat` -> `is_outlier_union.mat`

* `intensity.mat`, `is_outlier_union.mat` ->`intensity.mat`,  `intensity_volume.mat`

* 2 `intensity_volume.mat` -> figure



note:

* How to detect outliers?

  * Tukey test of the number of bright pixels of certian binary frame.
  * Tukey test of the intensity of certian volume.

* How to deal with outliers?

  * I will preserve outliers as nan in step 1-3.

  * I will plot outliers as nothing in step 4.



super-parameter

* sense threshold
* IQR index



parameter

* frame per volume: 5 or 10
* volume per second: 5 or 10
