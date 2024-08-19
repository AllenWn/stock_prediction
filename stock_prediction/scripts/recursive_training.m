
log = fopen('/Users/jianpingwei/Desktop/MatLab/training_log.txt', 'w');


numDays = size(training_data, 1);  

initialStep = 30;  

maxDays = 120;  

layerPerformance = struct();  


for i = 1:size(training_data, 2)
    meanValue = mean(training_data{:,i}, 'omitnan');
    stdValue = std(training_data{:,i}, 'omitnan');
    if stdValue == 0
        training_data{:,i} = zeros(size(training_data{:,i}));
    else
        training_data{:,i} = (training_data{:,i} - meanValue) / stdValue;
    end
end


for step = initialStep:initialStep:maxDays
    if numDays - step < 1
        break;  
    end
    fprintf(log, 'step %d 天的数据开始训练...\n', step);


    dataSubset = training_data(end-step+1:end, :);


    X = dataSubset(1:end-1, :);
    y = dataSubset(2:end, 'High');


    X = table2array(X);
    y = table2array(y);

    bestPerformance = -inf; 
    bestLayer = 0;

    for layers = 1:10
        net = feedforwardnet(layers, 'trainbr');
        net.trainParam.lr = 0.01;
        net.divideParam.trainRatio = 0.70;
        net.divideParam.valRatio = 0.15;
        net.divideParam.testRatio = 0.15;

        [net, tr] = train(net, X', y');


        R_train = 1 - (tr.perf / var(y(tr.trainInd)));
        R_val = 1 - (tr.vperf / var(y(tr.valInd)));
        R_test = 1 - (tr.tperf / var(y(tr.testInd)));

        %fprintf(log, 'step %d, layer %d, R_train: %f, R_val: %f, R_test: %f\n', step, layers, R_train, R_val, R_test);

        if R_val > bestPerformance
            bestPerformance = R_val;
            bestLayer = layers;
            bestNet = net;
        end
    end

    layerPerformance.(sprintf('step%d', step)) = struct('bestPerformance', bestPerformance, 'bestLayer', bestLayer);
    fprintf(log, '步长 %d 下，效果最好的层数为 %d，R_val 为 %f\n', step, bestLayer, bestPerformance);
end

maxOverallPerformance = -inf;
optimalStep = 0;
optimalLayers = 0;
for step = fieldnames(layerPerformance)'
    stepData = layerPerformance.(step{1});
    if stepData.bestPerformance > maxOverallPerformance
        maxOverallPerformance = stepData.bestPerformance;
        optimalStep = str2double(regexprep(step{1}, 'step', ''));
        optimalLayers = stepData.bestLayer;
    end
end

fprintf(log, '总体最优的步长为 %d，层数为 %d，R_val 为 %f\n', optimalStep, optimalLayers, maxOverallPerformance);
fclose(log); 
save('bestModel.mat', 'bestNet'); 