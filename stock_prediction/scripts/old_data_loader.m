function [training_x, training_y] = data_loader(file_root, x_range, y_range)
    training_x = readtable(file_root, 'Range', x_range);
    training_y = readtable(file_root, 'Range', y_range);
end