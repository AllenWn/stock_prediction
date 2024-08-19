fileRoot = '/Users/jianpingwei/Desktop/MatLab/stock_prediction/data/AAPL.csv';

% xRange = 'B2:G11005';
% yRange = 'C3:C11006';

cols_x = {'Low'};      % 想要读取的列
row_start_x = 2;                   % x数据的开始行
row_end_x = 5;                     % x数据的结束行
cols_y = {'Low'};                     % y数据想要读取的列，只有一个元素
row_start_y = 3;                   % y数据的开始行
row_end_y = 6;                     % y数据的结束行

logFilePath = '/Users/jianpingwei/Desktop/MATLAB/stock_prediction/training_log.txt';
saveDir = '/Users/jianpingwei/Desktop/MatLab/stock_prediction/models';
modelName = 'AAPL_stage1.mat';

startSize = 30;  % 开始窗口大小
stepSize = 15;   % 步长
maxSize = 400;   % 最大窗口大小


[training_x, training_y] = data_loader(fileRoot, cols_x, row_start_x, row_end_x, cols_y, row_start_y, row_end_y);


% bestModel = train_model(training_x, training_y, startSize, stepSize, maxSize, logFilePath, saveDir, modelName);