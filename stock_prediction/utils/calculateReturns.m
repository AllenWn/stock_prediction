function calculateReturns(filepath)

    opts = detectImportOptions(filepath);
    data = readtable(filepath, opts);
    
    closePrices = data.Close;  
    returns = [NaN; diff(log(closePrices))];  
    
    data.Returns = returns;
    
    writetable(data, filepath);
    
    disp(['Data with returns saved to ' filepath]);
end