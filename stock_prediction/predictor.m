function predict_y = predictor(bestModel, predict_x)
   
    if size(predict_x, 1) == 1 && size(predict_x, 2) == 6
        predict_x = predict_x';  
    end

    predict_y = sim(bestModel, predict_x);

    disp('Predicted output:');
    disp(predict_y);
    
end