
inputs = table2array(training_x);
targets = table2array(training_y);

hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize, 'trainbr'); 

net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};

net.divideFcn = 'dividerand';  % 随机划分
net.divideMode = 'sample';  % 每个样本单独划分
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

[net,tr] = train(net,inputs',targets');


outputs = net(inputs');
errors = gsubtract(targets',outputs);
performance = perform(net,targets',outputs);

targetsTransformed = targets'; 

SStot = sum((targetsTransformed - mean(targetsTransformed)).^2);  % 总平方和
SSres = sum((targetsTransformed - outputs).^2);  % 残差平方和
R_squared = 1 - SSres / SStot;  % R 值

mse = perform(net, targetsTransformed, outputs);


% 正规化MSE得分
mse_score = 1 / (1 + mse);  

weights = [0.5, 0.5]; % MSE, R^2 
scores = [mse_score, R_squared]; 
total_score = sum(weights .* scores);

fid = fopen('/Users/jianpingwei/Desktop/MatLab/training_log.txt', 'w');

fprintf(fid, 'Training completed with %d epochs.\n', tr.num_epochs);
fprintf(fid, 'Best performance at epoch: %d.\n', tr.best_epoch);
fprintf(fid, 'Final MSE: %.4f\n', mse);

% fprintf(fid, 'Correlation coefficient (R): %.4f\n', R);
fprintf(fid, 'Determination coefficient (R²): %.4f\n', R_squared);

fprintf(fid, 'Weighted Score: %.4f\n', total_score);

fclose(fid);

view(net);% 网络表现
% plotperform(tr);% 训练状态
% plotregression(targets', outputs);% 回归图
% ploterrhist(errors);% 误差直方图

save('trainedNetwork.mat', 'net', 'tr');