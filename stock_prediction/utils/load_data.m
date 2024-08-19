
fileroot = '/Users/jianpingwei/Desktop/MatLab/stock_prediction/data/AAPL.csv'; 

x_start = 'B2';
x_end = 'G11005';

y_start = 'C3';
y_end = 'C11006';

x_range = sprintf('%s:%s', x_start , x_end);
y_range = sprintf('%s:%s', y_start, y_end);

training_x = readtable(fileroot, 'Range', x_range);  

training_y = readtable(fileroot, 'Range', y_range);


assignin('base', 'training_x', training_x);
assignin('base', 'training_y', training_y);