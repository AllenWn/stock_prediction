function bestModel = lstm_train_model(inputs, targets, startSize, stepSize, maxSize, logFilePath, saveDir, modelName)
    inputs = table2array(inputs);
    targets = table2array(targets);

    bestPerformance = inf;
    bestModel = struct();
    bestEpoch = 0;
    bestWindowSize = 0;
    bestScore = 0;

    final_mse_score = 0;
    final_R_squared = 0;
    final_total_score = 0;

    fid = fopen(logFilePath, 'w');
    if fid == -1
        error('Failed to open log file.');
    end

    for windowSize = startSize:stepSize:maxSize
        endIndex = size(inputs, 1);
        if windowSize > endIndex
            fprintf(fid, 'Window size %d exceeds the number of available data points %d. Skipping...\n', windowSize, endIndex);
            continue;
        end

        startIndex = max(1, endIndex - windowSize + 1);
        windowInputs = inputs(startIndex:endIndex, :);
        windowTargets = targets(startIndex:endIndex);

        numFeatures = size(windowInputs, 2);
        numResponses = 1;
        numHiddenUnits = 10;

        layers = [ ...
            sequenceInputLayer(numFeatures)
            lstmLayer(numHiddenUnits,'OutputMode','sequence')
            fullyConnectedLayer(numResponses)
            regressionLayer];

        options = trainingOptions('adam', ...
            'MaxEpochs',100, ...
            'MiniBatchSize', windowSize, ...
            'GradientThreshold',1, ...
            'InitialLearnRate',0.005, ...
            'Shuffle','never', ...
            'Verbose',0, ...
            'Plots','training-progress');

        net = trainNetwork(windowInputs', windowTargets', layers, options);
        disp(['Training completed for window size ', num2str(windowSize)]);

        outputs = predict(net, windowInputs');
        errors = gsubtract(windowTargets',outputs);
        performance = perform(net,windowTargets',outputs);
        
        mse = mean(errors.^2);  % mse score
        disp(['MSE: ', num2str(mse)]);

        SStot = sum((windowTargets' - mean(windowTargets')).^2);  % 总平方和
        SSres = sum((windowTargets' - outputs).^2);  % 残差平方和
        R_squared = 1 - SSres / SStot;  % R 值

        mse_score = 1 / (1 + mse);
        weights = [0.5, 0.5];  % MSE, R^2 
        scores = [mse_score, R_squared];
        total_score = sum(weights .* scores);

        if total_score > bestScore
            bestPerformance = mse;
            bestModel = net;
            bestEpoch = 0;  % LSTM does not have a best epoch like trainbr, removing best epoch tracking
            bestWindowSize = windowSize;
            bestScore = total_score;
            final_mse_score = mse_score;
            final_R_squared = R_squared;
            final_total_score = total_score;
        end

        fprintf(fid, 'Window Size: %d\n', windowSize);
        fprintf(fid, 'mse_score: %.4f\n', mse_score);
        fprintf(fid, 'R^2: %.4f\n', R_squared);
        fprintf(fid, 'Score: %.4f\n', total_score);
        fprintf(fid, '-------------------------------------\n');
    end
    
    fprintf(fid, 'Best Model: Window Size: %d, MSE: %.4f, mse_score: %.4f, R^2: %.4f, Score: %.4f\n', bestWindowSize, bestPerformance, final_mse_score, final_R_squared, final_total_score);
    
    fclose(fid);

    filePath = fullfile(saveDir, modelName);
    save(filePath, 'bestModel');
    return
end







function bestModel = lstm_train_model(inputs, targets, startSize, stepSize, maxSize, logFilePath, saveDir, modelName)
    inputs = table2array(inputs);
    targets = table2array(targets);

    bestPerformance = inf;
    bestModel = struct();
    bestScore = 0;

    fid = fopen(logFilePath, 'w');
    if fid == -1
        error('Failed to open log file.');
    end

    % 假设你有一部分数据用作验证集
    % 这里需要根据你的数据集进行分割
    % 以下是示意性代码，需要根据实际情况调整
    valIndex = floor(0.8 * size(inputs, 1));
    trainInputs = inputs(1:valIndex, :);
    trainTargets = targets(1:valIndex);
    valInputs = inputs(valIndex+1:end, :);
    valTargets = targets(valIndex+1:end);

    for windowSize = startSize:stepSize:maxSize
        endIndex = size(trainInputs, 1);
        if windowSize > endIndex
            fprintf(fid, 'Window size %d exceeds the number of available data points %d. Skipping...\n', windowSize, endIndex);
            continue;
        end

        startIndex = max(1, endIndex - windowSize + 1);
        windowInputs = trainInputs(startIndex:endIndex, :);
        windowTargets = trainTargets(startIndex:endIndex);

        numFeatures = size(windowInputs, 2);
        numHiddenUnits = 10;

        layers = [ ...
            sequenceInputLayer(numFeatures)
            lstmLayer(numHiddenUnits,'OutputMode','last')
            fullyConnectedLayer(1)
            regressionLayer];

        options = trainingOptions('adam', ...
            'MaxEpochs',100, ...
            'MiniBatchSize', windowSize, ...
            'GradientThreshold',1, ...
            'InitialLearnRate',0.005, ...
            'Shuffle','never', ...
            'Verbose',0, ...
            'Plots','training-progress', ...
            'ValidationData', {valInputs', valTargets'}, ...
            'ValidationFrequency',5, ...
            'ValidationPatience',5);

        [net, tr] = trainNetwork(windowInputs', windowTargets', layers, options);

        % 选择最佳模型基于验证性能
        valPerformance = min(tr.ValidationLosses);
        if valPerformance < bestPerformance
            bestPerformance = valPerformance;
            bestModel = net;
            bestScore = valPerformance; % 这里的评分机制可以根据需求调整
        end
    end

    fprintf(fid, 'Best Model: Validation Loss: %.4f\n', bestPerformance);
    fclose(fid);

    filePath = fullfile(saveDir, modelName);
    save(filePath, 'bestModel');
    return
end