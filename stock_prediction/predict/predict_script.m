% predict_y = zeros(1,1);
% predict_y(1,1) = sim(x36days.Network,predict_x(1,:);

model_root = '/Users/jianpingwei/Desktop/MATLAB/stock_prediction/models/AAPL_stage1.mat'
load(model_root, 'bestModel');

if size(predict_x, 1) == 1 && size(predict_x, 2) == 6
    predict_x = predict_x';  
end

predict_y = sim(bestModel, predict_x);

disp('Predicted output:');
disp(predict_y);