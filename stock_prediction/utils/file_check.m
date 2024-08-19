if any(isnan(training_data{:,:}))
    fprintf('存在NaN值，需要处理');
    training_data = fillmissing(training_data, 'linear', 'DataVariables', {'Open', 'High', 'Low', 'Close', 'Volume'});
end
fprintf("finished")