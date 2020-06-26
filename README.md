# destination_inference
 

matlab code for individual metro trip destination inference

graphical model

<img src="https://github.com/lijunsun/destination_inference/figure/graph.png" width="800">

require mex

mex mnrnd_mex_noscale.c
main.m


input data (train/test) should contain the following entries:
user_id,station_x,station_y,hour_x,hour_y


Reference:
Cheng, Z., Trépanier, M. & Sun, L. Probabilistic model for destination inference and travel pattern mining from smart card data. Transportation (2020). https://doi.org/10.1007/s11116-020-10120-0
