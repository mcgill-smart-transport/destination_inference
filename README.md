# destination inference model
 

matlab code for individual metro trip destination inference based on smart card data

Each user contains a set of tuples (origin, time, destination) {(w^o, w^t, w^d)}. 
The objective is to get the destination probability of a new trip p_u(w^di|w^oi,w^ti,w^o{all except i},w^t{all except i},w^d{all except i}).

graphical model

<img src="https://github.com/lijunsun/destination_inference/blob/master/figure/graph.png" width="400">

require mex

mex mnrnd_mex_noscale.c


main.m


input data (train/test) should contain the following entries:


user_id,station_x,station_y,hour_x,hour_y


Reference:

Cheng, Z., Trépanier, M. & Sun, L. Probabilistic model for destination inference and travel pattern mining from smart card data. Transportation (2020). https://doi.org/10.1007/s11116-020-10120-0
