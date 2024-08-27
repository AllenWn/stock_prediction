function rolling_window_test(fileRoot, cols_x, row_start_x, row_end_x, cols_y, row_start_y, row_end_y, startSize, stepSize, maxSize, logFilePath, saveDir, modelName, testSize)
    
    fid = fopen(logFilePath, 'w');
    if fid == -1
        error('Failed to open log file.');
    end

    totalDays = row_end_x - row_start_x;
    fprintf('Starting rolling window test...\n');

    MSE = 0;


    for dayback = 0:1:testSize

        fprintf('Testing with dayback: %d...\n', dayback);
        
        fprintf(fid,'Test Dayback: %d\n', dayback);
        fprintf(fid, '-------------------------------------\n');

        row_end_X = row_end_x - dayback;
        row_end_Y = row_end_y - dayback;

        [training_x, training_y] = data_loader(fileRoot, cols_x, row_start_x, row_end_X, cols_y, row_start_y, row_end_Y);
        [test_x, test_y] = data_loader(fileRoot, cols_x, row_end_X + 1, row_end_X + 1, cols_y, row_end_Y + 1, row_end_Y + 1);
        

        if istable(test_x)
            test_x = table2array(test_x);
        end

        if istable(test_y)
            test_y = table2array(test_y);
        end

        bestModel = fitnet_train_model(training_x, training_y, startSize, stepSize, maxSize, fid, saveDir, modelName);

        predicted_y = predictor(bestModel, test_x);

        errors = test_y - predicted_y;
        sMSE = errors ^2;

        MSE = MSE + sMSE;
        % std_dev = std(errors);



        fprintf('Error: %.4f, MSE: %.4f', errors, sMSE);
        
        fprintf(fid, 'Test Dayback: %d, Predicted: %.4f, Actual: %.4f, Errors: %.4f, MSEv: %.4f\n', dayback, predicted_y, test_y, errors, sMSE);
        fprintf(fid, '=========================================================================================\n\n\n');

    end
    fid = fopen(logFilePath, 'a');
    splitname = strsplit(fileRoot, '/');
    filename = splitname{end};
    MSE = MSE / testSize;
    fprintf(fid, '\n---------------------------------------------------\n');
    fprintf(fid, 'Traning Data: %s, Test Epoch: %d, MSE: %.4f\n', filename, testSize, MSE);
    fprintf(fid, '---------------------------------------------------');
    fclose(fid);
end
