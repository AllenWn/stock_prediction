filename = '/Users/jianpingwei/Desktop/MatLab/stock_prediction/data/AAPL.csv';

opts = detectImportOptions(filename);
data = readtable(filename, opts);

period = 5;

summaryData = table();

numPeriods = floor(height(data) / period);

for i = numPeriods:-1:1

    startIndex = height(data) - i * period + 1;
    endIndex = startIndex + period - 1;

    currentData = data(startIndex:endIndex, :);

    avgOpen = mean(currentData.Open);
    avgClose = mean(currentData.Close);
    avgHigh = mean(currentData.High);
    avgLow = mean(currentData.Low);


    maxHigh = max(currentData.High);
    minLow = min(currentData.Low);

    firstDayOpen = currentData.Open(1);
    lastDayClose = currentData.Close(end);

    totalVolume = sum(currentData.Volume);

    weekOpenPrice = currentData.Open(1);
    weekClosePrice = currentData.Close(end); 
    weekReturns = (weekClosePrice / weekOpenPrice - 1) * 100;

    
    weekStartDate = currentData.Date(1);  
    % weekStartDate = datestr(currentData.Date(1), 'yyyy/mm/dd'); % 如果需要将日期向量格式化为字符串


    summaryData = [summaryData; {weekStartDate, avgOpen, avgHigh, avgLow, avgClose, maxHigh, minLow, firstDayOpen, lastDayClose, totalVolume, weekReturns}];
end

% summaryData = flipud(summaryData);

summaryData.Properties.VariableNames = {'WeekStartDate', 'AvgOpen', 'AvgHigh', 'AvgLow', 'AvgClose', 'MaxHigh', 'MinLow', 'firstDayOpen', 'lastDayClose', 'TotalVolume', 'WeekReturns'};


writetable(summaryData, '../data/AAPL_wkreturn.csv');