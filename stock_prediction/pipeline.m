fileRoot = '/Users/jianpingwei/Desktop/MatLab/stock_prediction/data/AAPL.csv';


cols_x = {'B', 'C', 'D', 'E', 'F', 'G'};
row_start_x = 9999;
row_end_x = 10999;
cols_y = {'E'};
row_start_y = 10000;
row_end_y = 11000;


logFilePath = '/Users/jianpingwei/Desktop/MATLAB/stock_prediction/training_log.txt';
saveDir = '/Users/jianpingwei/Desktop/MatLab/stock_prediction/models';
modelName = 'NVDA_high.mat';

startSize = 30;  
stepSize = 30;  
maxSize = 120;  
testSize = 5;

% [training_x, training_y] = data_loader(fileRoot, cols_x, row_start_x, row_end_x, cols_y, row_start_y, row_end_y);


% bestModel = fitnet_train_model(training_x, training_y, startSize, stepSize, maxSize, logFilePath, saveDir, modelName);


rolling_window_test(fileRoot, cols_x, row_start_x, row_end_x, cols_y, row_start_y, row_end_y, startSize, stepSize, maxSize, logFilePath, saveDir, modelName, testSize);