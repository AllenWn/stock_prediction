
filename = '/Users/jianpingwei/Desktop/MatLab/stock_prediction/data/AAPL.csv';

opts = detectImportOptions(filename);
data = readtable(filename, opts);


data.Date = datetime(data.Date);


summaryData = table();


startDate = min(data.Date);
endDate = max(data.Date);

allWeekdays = startDate:endDate;
allWeekdays = allWeekdays(weekday(allWeekdays) >= 2 & weekday(allWeekdays) <= 6);

currentWeek = [];
for i = 1:length(allWeekdays)
    currentData = data(ismember(data.Date, allWeekdays(i)), :);
    if ~isempty(currentData)
        currentWeek = [currentWeek; currentData];
    end

    if weekday(allWeekdays(i)) == 6 || i == length(allWeekdays) % 周五或者最后一个数据
        if height(currentWeek) >= 4 % 确保至少有4个工作日的数据
           
            summaryData = processWeekData(currentWeek, summaryData);
        end
        
        currentWeek = [];
    end
end

function summaryTable = processWeekData(weekData, summaryTable)
    avgOpen = mean(weekData.Open);
    avgClose = mean(weekData.Close);
    avgHigh = mean(weekData.High);
    avgLow = mean(weekData.Low);
    maxHigh = max(weekData.High);
    minLow = min(weekData.Low);
    firstDayOpen = weekData.Open(1);
    lastDayClose = weekData.Close(end);
    totalVolume = sum(weekData.Volume);
    weekReturns = (lastDayClose / firstDayOpen - 1) * 100;
    weekStartDate = weekData.Date(1);
    newRow = table(weekStartDate, avgOpen, avgHigh, avgLow, avgClose, maxHigh, minLow, firstDayOpen, lastDayClose, totalVolume, weekReturns, ...
        'VariableNames', {'WeekStartDate', 'AvgOpen', 'AvgHigh', 'AvgLow', 'AvgClose', 'MaxHigh', 'MinLow', 'FirstDayOpen', 'LastDayClose', 'TotalVolume', 'WeekReturns'});
    summaryTable = [summaryTable; newRow];
end

outputFilename = '../data/processed_stock_data.csv';

writetable(summaryData, outputFilename);