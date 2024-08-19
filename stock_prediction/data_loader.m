function [training_x, training_y] = data_loader(file_root, cols_x, row_start_x, row_end_x, cols_y, row_start_y, row_end_y)
    % 构造完整的读取区域，确保从 cell 数组中提取字符串
    range_x = sprintf('%s%d:%s%d', cols_x{1}, row_start_x, cols_x{end}, row_end_x);
    range_y = sprintf('%s%d:%s%d', cols_y{1}, row_start_y, cols_y{end}, row_end_y);

    % 读取指定的列，处理单列和多列的情况
    opts_x = detectImportOptions(file_root, 'Range', range_x);
    opts_x.SelectedVariableNames = cols_x;  % 确保只选取指定列
    training_x = readtable(file_root, opts_x);

    opts_y = detectImportOptions(file_root, 'Range', range_y);
    opts_y.SelectedVariableNames = cols_y;  % 确保只选取指定列
    training_y = readtable(file_root, opts_y);
end