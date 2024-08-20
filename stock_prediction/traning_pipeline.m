fileRoot = '/Users/jianpingwei/Desktop/MatLab/stock_prediction/data/AAPL.csv';

% xRange = 'B2:G11005';
% yRange = 'C3:C11006';

cols_x = {'B', 'C', 'E', 'F'};
row_start_x = 2;
row_end_x = 5;
cols_y = {'D'};
row_start_y = 3;
row_end_y = 6;

logFilePath = '/Users/jianpingwei/Desktop/MATLAB/stock_prediction/training_log.txt';
saveDir = '/Users/jianpingwei/Desktop/MatLab/stock_prediction/models';
modelName = 'AAPL_stage1.mat';

startSize = 30;  
stepSize = 15;  
maxSize = 400;  


[training_x, training_y] = data_loader(fileRoot, cols_x, row_start_x, row_end_x, cols_y, row_start_y, row_end_y);


bestModel = train_model(training_x, training_y, startSize, stepSize, maxSize, logFilePath, saveDir, modelName);