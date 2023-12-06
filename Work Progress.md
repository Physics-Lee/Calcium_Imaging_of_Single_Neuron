# Weekly Progress

## 2023SP

2023-03-23

MSE

---

2023-03-30

MSE

**$f(\theta - \theta_{in}|\theta_{in})$**

---

2023-04-06

the data screen problem

pair-wise MSE

index 

cos-to-ideal (also called cos distance, Pearson Correlation Coefficient)

---

2023-04-13

the multiple comparison problem

track timescale

run time scale

RIA, RMD, SMD

---

2023-04-20

**$f(\Delta \theta \ between \ 1 \ frame|\theta_{in})$**

**$f(\Delta \theta \ between \ 9 \ frames|\theta_{in})$**

----

2023-04-27

chemo-index and thermo-index in ortho.

t-test p-value matrix.

---

2023-05-04

skip, because of the International Workers' Day

---

2023-05-11

**persistent length.**

---

2023-05-18

persistent length.

----

2023-05-25

**machine label of Colbert**

----

2023-06-01

run longer than 20s, by taking subsets of each run

v, by taking subsets of each run

---

2023-06-08

The last 2 measures are not suitable by taking subsets of each run.

---

2023-06-15

skip.

---

2023-06-20 (2023-06-22 is the Dragon Boat Festival)

- Persistent Length plots are only valid within 0-2 mm.
- The SMD and RMD test group shows difference compared with the control group in 0-1mm
- Using std or $\Delta \theta$, we can only label the "sharp shallow turn", we can't label the "shallow shallow turn"

---

2023-06-29

skip, because of COSYNE

---

2023-07-06

skip, because of COSYNE

---

2023-07-13

Reproduce persistent length, v, index on Colbert data

---

2023-07-20

Reproduce Poisson Process on Colbert Data

Work Report

---

2023-07-27

my first NC exp on the weekend.

---

2023-08-03, 2023-08-10

get the trajectory of planarian.

---

2023-08-16, 2023-08-23, 2023-08-30

Summer Vacation



## 2023FA

2023-09-06, 2023-09-13

Learn DL.

---

2023-09-20

Label Roaming.

SMD-RMD co-ablation.

Theory JC.

---

2023-09-27, 2023-10-04

Iino-curving-rate.

---

2023-10-11

Change the Error Bar.

Markov Is All You Need.

---

2023-10-18

Change the Error Bar.

---

2023-10-25

Change the Error Bar (Use n threshold).

Weighted Average (Weighted by Time).

---

2023-11-01

$r, I_{mutual}$ will give similar results to cos.

In persistent length methods, methods try to using the ideal theta do not work very well, because of the "intrinsic bias".

---

2023-11-08

继往开来

---

2023-11-15

Auto Corr

---

2023-11-22

Run example of ZephIR

---

2023-11-29

Run example of ZephIR

---

2023-12-06

use adaptive binarization to get the intensity.

Work Report



# 学到了什么？

我从这个课题上学到了什么？

* 设置label, title, legend：回头来看，这是废话，但当时的我真的没这习惯。
* 设置axis equal：不设置的话，我的身高就只有40cm了。
* 设置ylim: 有的经济学家常常拿这点骗人，气候变暖否定者也常常拿这点骗人。
* 拿到数据后，不能只看mean和variance，还要看distribution！
  
  * 所含有的信息：distribution > violin plot or box plot > mean + variance > mean + median.
  * 推论
  
    * 直方图比box plot, violin plot等乱七八糟的强多了。
  
    * 有的经济学家常常强调平均数和中位数的区别，但能给出平均值和方差更好！
  
  * 但是，通常的生物论文里，只展示mean + variance或box plot或violin plot，这是一件愚蠢的事情。
* 检测异常值: Tukey Test is very useful for detecting outliers, at least in 1D.
* 简化到多少要适应你研究的问题：研究太阳和地球时，可以把它俩简化成质点；研究线虫的某些行为时，可以简化成质点（比如，趋盐、趋温的开山之作，都是数线虫个数，即看成质点）（再比如，大台子，persistent length，也把线虫看成质点）；研究线虫的另一些行为时，可以简化成centerline。（比如，张恒他们关心的头部运动）
* cor-relation
