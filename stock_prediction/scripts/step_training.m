
inputs = table2array(training_x);
targets = table2array(training_y);
disp(size(inputs));  
disp(size(targets));  

startSize = 30;  % 开始窗口大小
stepSize = 15;   % 步长
maxSize = 400;   % 最大窗口大小


bestPerformance = inf; 
bestModel = struct();
bestEpoch = 0;
bestWindowSize = 0;
bestScore = 0;


fid = fopen('training_log.txt', 'w');
if fid == -1
    error('Failed to open log file.');
end

disp('Starting the rolling window loop...');
for windowSize = startSize:stepSize:maxSize
    endIndex = size(inputs, 1);  
    if windowSize > endIndex
        fprintf(fid, 'Window size %d exceeds the number of available data points %d. Skipping...\n', windowSize, endIndex);
        continue;  
    end

    startIndex = max(1, endIndex - windowSize + 1); 
    windowInputs = inputs(startIndex:endIndex, :);
    windowTargets = targets(startIndex:endIndex);

    hiddenLayerSize = 10;
    net = fitnet(hiddenLayerSize, 'trainbr');
    net.input.processFcns = {'removeconstantrows','mapminmax'};
    net.output.processFcns = {'removeconstantrows','mapminmax'};
    

    [net,tr] = train(net, windowInputs', windowTargets');
    disp(['Training completed for window size ', num2str(windowSize)]);


    outputs = net(windowInputs');
    errors = gsubtract(windowTargets',outputs);
    performance = perform(net,windowTargets',outputs);
    
    targetsTransformed = windowTargets'; 
    mse = perform(net, targetsTransformed, outputs);% mse score
    disp(['MSE: ', num2str(mse)]);

    SStot = sum((targetsTransformed - mean(targetsTransformed)).^2);  % 总平方和
    SSres = sum((targetsTransformed - outputs).^2);  % 残差平方和
    R_squared = 1 - SSres / SStot;  % R 值


    mse_score = 1 / (1 + mse);  
    weights = [0.5, 0.5];  % MSE, R^2 
    scores = [mse_score, R_squared];
    total_score = sum(weights .* scores);


    if total_score > bestScore
        bestPerformance = mse;
        bestModel = net;
        bestEpoch = tr.best_epoch;
        bestWindowSize = windowSize;
        bestScore = total_score;
    end

  
    fprintf(fid, 'Window Size: %d\n', windowSize);
    fprintf(fid, 'mse_score: %.4f\n', mse_score);
    fprintf(fid, 'R^2: %.4f\n', R_squared);
    fprintf(fid, 'Score: %.4f\n', total_score);
    fprintf(fid, 'Best Epoch: %d\n', tr.best_epoch);
    fprintf(fid, '-------------------------------------\n');
end


fprintf(fid, 'Best Model: Window Size: %d, Best Epoch: %d, MSE: %.4f, mse_score: %.4f, R^2: %.4f, Score: %.4f\n', bestWindowSize, bestEpoch, bestPerformance, mse_score, R_squared, bestScore);
fclose(fid);

saveDir = '/Users/jianpingwei/Desktop/MatLab/stock_prediction/models';
modName = 'AAPL_stage1.mat';
filePath = fullfile(saveDir, modName);

save(filePath, 'bestModel'); % , 'bestPerformance', 'bestEpoch', 'bestWindowSize', 'bestScore');

