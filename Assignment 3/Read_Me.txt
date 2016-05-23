Hello,

I have used R to write my code, you can find the codes inside the zip in code folder.
I have also downloaded all the data sets and converted them into test / training CSV and is enclosed in the zip.

Multi-class Perceptron are implemented using hidden = 0 in neuralnet code. Please, change it back to hidden = c(2) for running neural network.


I have put all the instruction wherever required as comments in the r files.

Common error which can still come are - 

1. Error in neurons[[i]] %*% weights[[i]] : 
  requires numeric/complex matrix/vector arguments

in that case, please, do str(traindata) or str(testdata) and look out for column type "Factor".

> str(testdata)
'data.frame':	199 obs. of  9 variables:
 $ Sex           : Factor w/ 3 levels "F","I","M": 2 2 3 2 2 2 2 3 3 2 ...
 $ Length        : num  0.14 0.18 0.18 0.19 0.165 0.215 0.205 0.175 0.195 0.165 ...
 $ Diameter      : num  0.105 0.13 0.125 0.14 0.12 0.15 0.155 0.125 0.145 0.11 ...
 $ Height        : num  0.035 0.045 0.05 0.03 0.05 0.055 0.045 0.04 0.05 0.02 ...
 $ Whole.weight  : num  0.014 0.0275 0.023 0.0315 0.021 0.041 0.0495 0.024 0.032 0.019 ...
 $ Shucked.weight: num  0.0055 0.0125 0.0085 0.0125 0.0075 0.015 0.0235 0.0095 0.01 0.0065 ...
 $ Viscera.weight: num  0.0025 0.01 0.0055 0.005 0.0045 0.009 0.011 0.006 0.008 0.0025 ...
 $ Shell.weight  : num  0.004 0.009 0.01 0.0105 0.014 0.0125 0.014 0.005 0.012 0.005 ...
 $ Rings         : int  3 3 3 3 3 3 3 4 4 4 ...

So change Sex to numeric using  traindata$Sex <- as.numeric(traindata$Sex )

2. Error in plot.nn(nn) : weights were not calculated
In addition: Warning message:
algorithm did not converge in 1 of 1 repetition(s) within the stepmax 

In which case alter the arguments hidden=, threshold = in
nn <- neuralnet(f,data=traindata,hidden=c(2), linear.output=T, threshold = 0.5)

This should be it.

PLEASE REACH OUT TO ME FOR ANY ISSUES OR CONCERN AND I WILL REVERT BACK IMMEDIATELY.

Your's Sincerely,
Dharmam
and it should run now.
