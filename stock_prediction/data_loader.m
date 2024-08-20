function [training_x, training_y] = data_loader(file_root, cols_x, row_start_x, row_end_x, cols_y, row_start_y, row_end_y)
    
    training_x_parts = cell(1, numel(cols_x));
    training_y_parts = cell(1, numel(cols_y));
    
    
    for i = 1:numel(cols_x)
        range_x = sprintf('%s%d:%s%d', cols_x{i}, row_start_x, cols_x{i}, row_end_x);
        temp_x = readtable(file_root, 'Range', range_x);
        temp_x.Properties.VariableNames = {cols_x{i}};  
        training_x_parts{i} = temp_x;
    end
    
    training_x = [training_x_parts{:}];

   
    for i = 1:numel(cols_y)
        range_y = sprintf('%s%d:%s%d', cols_y{i}, row_start_y, cols_y{i}, row_end_y);
        temp_y = readtable(file_root, 'Range', range_y);
        temp_y.Properties.VariableNames = {cols_y{i}};  
        training_y_parts{i} = temp_y;
    end
  
    training_y = [training_y_parts{:}];
end