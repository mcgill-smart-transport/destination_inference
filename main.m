clearvars;
clc;
train_data = readtable('train.csv');
test_data = readtable('test.csv');

%%
ko = 20;
kt = 5;
[puzoztd, pozs, ptzs] = gibbs_new(train_data, ko, kt, 1000, 100, 20, 1);
prediction = zeros(height(train_data), 1);


for i = 1:height(train_data)
    u = train_data.id(i);
    o = train_data.station_x(i);
    t = train_data.hour_x(i);

    pz = pozs(o, :)'*ptzs(t, :);
    pz = pz(:);
    zoztd = puzoztd(u, :,:,:);
    pzd = reshape(zoztd(:), [ko*kt, 159]);
    [~,d] = max(sum(pzd.*pz));
    prediction(i) = d;
end

right_rate_train = sum(prediction==train_data.station_y)/size(train_data,1);

% Test set
prediction2 = zeros(height(test_data), 1);

for i = 1:height(test_data)
    u = test_data.id(i);
    o = test_data.station_x(i);
    t = test_data.hour_x(i);

    pz = pozs(o, :)'*ptzs(t, :);
    pz = pz(:);
    zoztd = squeeze(puzoztd(u, :,:,:));
    pzd = reshape(zoztd, [ko*kt, 159]);
    [~,d] = max(sum(pzd.*pz));
    
    prediction2(i) = d;
end

right_rate_test = sum(prediction2==test_data.station_y)/size(test_data,1);

%%

x = confusionmat(test_data.station_y,prediction2);
subplot(1,2,1);
imagesc(log(x));
subplot(1,2,2);
x = x./sum(x,2);
imagesc(x);
