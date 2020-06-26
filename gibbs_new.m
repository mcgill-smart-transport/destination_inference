function [puzoztd, pozs, ptzs] = gibbs_new(train_data, Ko, Kt, maxiter, sample_iter, everyiter, plotf)

clc
u_list = train_data.id;
o_list = train_data.station_x;
d_list = train_data.station_y;
t_list = train_data.hour_x;

num_data = length(o_list);
num_user = max(u_list);
num_station = max([o_list;d_list]); % although data not covers all stations
num_time = max(t_list);



zo_list = randi(Ko,[num_data,1]);
zt_list = randi(Kt,[num_data,1]);
uzozt = zeros(num_user,Ko,Kt);
uzoztd = zeros(num_user,Ko,Kt,num_station);
nozs = zeros(num_station,Ko);
ntzs = zeros(num_time,Kt);
noz = zeros(1,Ko);
ntz = zeros(1,Kt);

nuzo = zeros(num_user,Ko);
nuzt = zeros(num_user,Kt);

puzoztd = zeros(num_user,Ko,Kt,num_station);
pozs = zeros(num_station,Ko);
ptzs = zeros(num_time,Kt);

for idx = 1:num_data
    u = u_list(idx);
    t = t_list(idx);
    o = o_list(idx);
    d = d_list(idx);
    zt = zt_list(idx);
    zo = zo_list(idx);
    uzozt(u,zo,zt) = uzozt(u,zo,zt) + 1;
    uzoztd(u,zo,zt,d) = uzoztd(u,zo,zt,d) + 1;
    nozs(o,zo) = nozs(o,zo) + 1;
    ntzs(t,zt) = ntzs(t,zt) + 1;
    noz(zo) = noz(zo) + 1;
    ntz(zt) = ntz(zt) + 1;
    
    nuzo(u,zo) = nuzo(u,zo) + 1;
    nuzt(u,zt) = nuzt(u,zt) + 1;
    
    
end

%%

beta = 0.1;
gamma = 0.1;

st = tic;
for iter = 1:maxiter+sample_iter
    for idx = 1:num_data
        u = u_list(idx);
        t = t_list(idx);
        o = o_list(idx);
        d = d_list(idx);
        zt = zt_list(idx);
        zo = zo_list(idx);
        
        noz(zo) = noz(zo) - 1;
        ntz(zt) = ntz(zt) - 1;
        nuzo(u,zo) = nuzo(u,zo) - 1;
        nuzt(u,zt) = nuzt(u,zt) - 1;

        uzoztd(u,zo,zt,d) = uzoztd(u,zo,zt,d) - 1;
        
        nozs(o,zo) = nozs(o,zo) - 1;
        po = uzoztd(u,:,zt,d)+gamma;
        po = (po./(nuzo(u,:)+num_station*gamma)).*(nozs(o,:)+beta);
        
        
        
        ntzs(t,zt) = ntzs(t,zt) - 1;
        
        pt = uzoztd(u,zo,:,d)+gamma;
        pt = pt(:)';
        pt = pt./(nuzt(u,:) + num_time*gamma).*(ntzs(t,:)+beta);
        
        zo = mnrnd_mex_noscale(po);
        nozs(o,zo) = nozs(o,zo) + 1;
        zo_list(idx) = zo;
        
        zt = mnrnd_mex_noscale(pt);
        ntzs(t,zt) = ntzs(t,zt) + 1;
        zt_list(idx) = zt;
        
        noz(zo) = noz(zo) + 1;
        ntz(zt) = ntz(zt) + 1;
        nuzo(u,zo) = nuzo(u,zo) + 1;
        nuzt(u,zt) = nuzt(u,zt) + 1;
        uzoztd(u,zo,zt,d) = uzoztd(u,zo,zt,d) + 1;
        
    end
    
    if mod(iter,everyiter)==0
        t = toc(st);
        fprintf('Iter %i. Total time: %0.3f s\n', iter, t);
        if plotf
            subplot(1,2,1);
            plot(ntzs);
            subplot(1,2,2);
            imagesc(nozs);
            drawnow;
        end
    end
    
    if iter>maxiter
        pozs = pozs + (nozs + beta);
        ptzs = ptzs + (ntzs + beta);
        puzoztd = puzoztd + (uzoztd);
    end
    
end

pozs = pozs./sum(pozs, 2);
ptzs = ptzs./sum(ptzs, 2);
puzoztd = puzoztd./sum(puzoztd, [2,3,4]);
