fileRoot = '/Users/jianpingwei/Desktop/MatLab/stock_prediction/data/NVDA.csv';

% xRange = 'B2:G11005';
% yRange = 'C3:C11006';

cols_x = {'B', 'C', 'D', 'E', 'F', 'G'};
row_start_x = 6400;
row_end_x = 6434;
cols_y = {'E'};
row_start_y = 6401;
row_end_y = 6435;

logFilePath = '/Users/jianpingwei/Desktop/MATLAB/stock_prediction/training_log.txt';
saveDir = '/Users/jianpingwei/Desktop/MatLab/stock_prediction/models';
modelName = 'NVDA_high.mat';

startSize = 5;  
stepSize = 1;  
maxSize = 34;  


[training_x, training_y] = data_loader(fileRoot, cols_x, row_start_x, row_end_x, cols_y, row_start_y, row_end_y);


bestModel = train_model(training_x, training_y, startSize, stepSize, maxSize, logFilePath, saveDir, modelName);