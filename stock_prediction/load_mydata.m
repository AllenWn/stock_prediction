%rate1 = table('High','low','myHigh','正确','错误','总数','最新正确率');
fileroot = 'data.xlsx'; 
logFilePath = 'log.xlsx';
fid = fopen(logFilePath, 'w');
    if fid == -1
        error('Failed to open log file.');
    end

training_x=zeros(1,1);
training_o=zeros(1,1);  % 开盘
training_h=zeros(1,1);  %高点
training_l=zeros(1,1);  %低点
training_c=zeros(1,1);  %收盘
predict_x = zeros(1,1);
predict_xa = zeros(1,1);
predict_yo = zeros(1,1);
predict_yh = zeros(1,1);
predict_yl = zeros(1,1);
predict_yc = zeros(1,1);
predict_com = zeros(1,1);

p1 = 1;%预测值筛选标准
tablecol = 2173; %股票数据行数
step1 = 30; %训练步长
col_d = 2; %训练天数
col_e = tablecol-2;%训练的结尾行，如果是最后一行需要留2行用于预测
train_cbi = col_e-col_d-step1; %训练矩阵的起始位置行
train_cei = col_e;
g = 0; %记录符合预测条件的天数
day1 = 1; %记录预测天数
cont1 = 0;
rate1 = zeros(1,1);
for j= train_cei:train_cbi %从末尾到启示
    cont1 = cont1+1; %用于在循环里面计数
    r = 0;%正确率
    f = 0;%错误率
    train_cb = j-30; %训练矩阵的起始位置行
    train_ce = j;
    train_yb=train_cb + 1;%训练结果第一行矩阵左上角所在行+1
    train_ye=train_ce + 1;%训练结果最后一行矩阵右下角所在行+1

    predict_col=train_ce + 2;%预测结果行

    train_cb1=int2str(train_cb);
    train_ce1=int2str(train_ce);
    train_yb1=int2str(train_yb);
    train_ye1=int2str(train_ye);

    predict_col1=int2str(predict_col);

    x_start = strcat('B',train_cb1); %训练矩阵左上角所在行
    x_end =  strcat('G',train_ce1); %训练矩阵右下角所在行

    % 开盘价open
    o_start = strcat('B',train_yb1);
    o_end = strcat('B',train_ye1);

    % 最高价High
    h_start =strcat('C',train_yb1);
    h_end = strcat('C',train_ye1);

    %最低价low
    l_start = strcat('D',train_yb1);
    l_end = strcat('D',train_ye1);


    %收盘价close
    c_start = strcat('E',train_yb1);
    c_end = strcat('E',train_ye1);



    %预测输入
    p_start = strcat('B',train_ye1);
    p_end = strcat('G',train_ye1);

    %比较行(预测输入+1)
    com_start = strcat('A',predict_col1);
    com_end = strcat('E',predict_col1);


    x_range = sprintf('%s:%s', x_start , x_end);
    o_range = sprintf('%s:%s', o_start, o_end);
    h_range = sprintf('%s:%s', h_start, h_end);
    l_range = sprintf('%s:%s', l_start, l_end);
    c_range = sprintf('%s:%s', c_start, c_end);

    p_range = sprintf('%s:%s', p_start, p_end);
    com_range = sprintf('%s:%s', com_start, com_end);


    training_x = readtable(fileroot, 'Range', x_range,ReadVariableNames=false);

    training_o = readtable(fileroot, 'Range', o_range,ReadVariableNames=false);
    training_h = readtable(fileroot, 'Range', h_range,ReadVariableNames=false);
    training_l = readtable(fileroot, 'Range', l_range,ReadVariableNames=false);
    training_c = readtable(fileroot, 'Range', c_range,ReadVariableNames=false);

    predict_x = readtable(fileroot, 'Range', p_range,ReadVariableNames=false);
    predict_com = readtable(fileroot, 'Range', com_range,ReadVariableNames=false);


    assignin('base', 'training_x', training_x);
    assignin('base', 'training_o', training_o);
    assignin('base', 'training_h', training_h);
    assignin('base', 'training_l', training_l);
    assignin('base', 'training_c', training_c);
    assignin('base', 'predict_x', predict_x);
    assignin('base', 'predict_com', predict_com);

    predict_com{1,6}=(predict_com{1,3}-predict_x{1,4})/predict_x{1,4}*100;
    predict_com{1,7}=(predict_com{1,4}-predict_x{1,4})/predict_x{1,4}*100;
    predict_com{1,8}=predict_x{1,4};

    % net = feedforwardnet(10, 'trainbr');
    % fprintf(log, '步长 %d 下，效果最好的层数为 %d，R_val 为 %f\n', step, bestLayer, bestPerformance);
    inputs1 = table2array(training_x);
    targets1_o = table2array(training_o);
    targets1_h = table2array(training_h);
    targets1_l = table2array(training_l);
    targets1_c = table2array(training_c);

    predict_xa = table2array(predict_x);


    % training
    hiddenLayerSize = 10;
    net1 = fitnet(hiddenLayerSize, 'trainbr');
    %net1 = arima(hiddenLayerSize,'trainbr');%时序模型

    net1_feed = feedforwardnet(10, 'trainbr');


    %[net1,tr] = visionTransformer;

    %net1 = freezeNetwork(net1,LayersToIgnore="SelfAttentionLayer");


    % for i=3:5
    % [netmodel_o,tr] = train(net1,inputs1',targets1_o');
    % [netmodel_h,tr] = train(net1,inputs1',targets1_h');
    % [netmodel_l,tr] = train(net1,inputs1',targets1_l');
    % [netmodel_c,tr] = train(net1,inputs1',targets1_c');
    %
    % %predict_y = netmodel(predict_xa');
    % predict_yo = sim(netmodel_o, predict_xa');
    % predict_yh = sim(netmodel_h, predict_xa');
    % predict_yl = sim(netmodel_l, predict_xa');
    % predict_yc = sim(netmodel_c, predict_xa');
    %
    % predict_com{i,2} = predict_yo ;
    % predict_com{i,3} = predict_yh ;
    % predict_com{i,4} = predict_yl ;
    % predict_com{i,5} = predict_yc ;
    %
    % predict_com{i,6} = (predict_yh-predict_x{1,4})/predict_x{1,4}*100;
    % predict_com{i,7} = (predict_yl-predict_x{1,4})/predict_x{1,4}*100;
    % end


    gi = 0; %用于记录同一个模型不同训练的预测结果是否符合给定条件
    for i=7:9 % i值取值大 是想不同模型可以叠加
       %  [netmodel_o,tr] = train(net1_feed,inputs1',targets1_o');
        [netmodel_h,tr] = train(net1_feed,inputs1',targets1_h');
        [netmodel_l,tr] = train(net1_feed,inputs1',targets1_l');
        % [netmodel_c,tr] = train(net1_feed,inputs1',targets1_c');

        % predict_yo = sim(netmodel_o, predict_xa');
        predict_yh = sim(netmodel_h, predict_xa');
        predict_yl = sim(netmodel_l, predict_xa');
        % predict_yc = sim(netmodel_c, predict_xa');

        % predict_com{i,2} = predict_yo ;
        predict_com{i,3} = predict_yh ;
        predict_com{i,4} = predict_yl ;
        % predict_com{i,5} = predict_yc ;
        
        %预测的最高（低）值的百分比值
        predict_com{i,6} = (predict_yh-predict_x{1,4})/predict_x{1,4}*100;
        predict_com{i,7} = (predict_yl-predict_x{1,4})/predict_x{1,4}*100;
        
        if (predict_com{i,6}>p1) %预测值大于筛选值
            temp = predict_com{i,6}; 
            gi =gi+1 ; %避免同一模型多次训练重复技术
            if (gi==1)
                g= g+1; %预测结果符合标准的总数
            end
            if (predict_com{1,6}>p1)% 实际值也大于筛选值
                if (gi==1)
                    r=r+1; % 预测和实际结果都符合标准的计数器
                end
            else %实际小于1%
                if (gi==1)
                    f=f+1; % 预测符合但实际结果不符合标准的计数器
                end
            end
            %有效数据记入表格
            rate1{g,1} = predict_com{1,6};
            rate1{g,2} = predict_com{1,7};
            rate1{g,3} = temp;
            rate1{g,4} = r;
            rate1{g,5} = f;
            rate1{g,6} = g;
            rate1{g,7} = r/g*100;
        end

    end
    j = j+1;
end

writetable(rate1,'log.xlsx');


% predict_y = net(predict_x');
%errors = gsubtract(targets',outputs);
% performance = perform(net,targets',predict_y);
%disp(predict_yo,predict_yh,predict_yl,predict_yc);

%save('bestModel.mat', 'predict_x','predict_y','training_x','training_y');
%besttrain=3、2；