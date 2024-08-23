function bestModel = arima_train_model(inputs, targets, startSize, stepSize, maxSize, logFilePath, saveDir, modelName)
    inputs = table2array(inputs);  % 将表格转换为数组，如果inputs仅是时间序列的日期，可能不需要这步
    targets = table2array(targets);

    bestPerformance = inf;
    bestModel = [];
    fid = fopen(logFilePath, 'w');
    if fid == -1
        error('Failed to open log file.');
    end

    % 迭代不同的时间窗口
    for windowSize = startSize:stepSize:maxSize
        endIndex = length(targets);
        if windowSize > endIndex
            fprintf(fid, 'Window size %d exceeds the number of available data points %d. Skipping...\n', windowSize, endIndex);
            continue;
        end

        startIndex = max(1, endIndex - windowSize + 1);
        windowTargets = targets(startIndex:endIndex);

        % 定义ARIMA模型，这里可以调整模型参数
        model = arima('Constant', 0.5, 'D', 1, 'Seasonality', 12, 'MALags', 1, 'SARLags', 12);

        % 估计模型参数
        [estModel, estParam] = estimate(model, windowTargets, 'print', false);

        % 使用估计的模型进行预测
        [y, ~, logL] = infer(estModel, windowTargets);
        % 计算性能，这里使用的是对数似然作为性能衡量
        mse = mean((windowTargets - y).^2);
        
        if mse < bestPerformance
            bestPerformance = mse;
            bestModel = estModel;
        end

        fprintf(fid, 'Window Size: %d, MSE: %.4f, Log-Likelihood: %.4f\n', windowSize, mse, logL);
    end

    fprintf(fid, 'Best Model Performance: MSE: %.4f\n', bestPerformance);
    fclose(fid);

    filePath = fullfile(saveDir, modelName);
    save(filePath, 'bestModel');
end