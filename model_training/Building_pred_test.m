clear
clc
addpath data\
addpath function\
load data_cnn.mat

% define layers
layers = [
    % model 1
    imageInputLayer([10 520 1],"Name","imageinput")
    batchNormalizationLayer()

    convolution2dLayer([3 3],10,"Name","conv","Padding","same")
    reluLayer("Name","relu")
    maxPooling2dLayer([2 2],"Name","maxpool","Padding","same")

    fullyConnectedLayer(3,"Name","fc")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];


% hyperparameters
options = trainingOptions('adam',...                         % or adam、rmsprop,sgdm
                          'MiniBatchSize',100, ...            % only with validation set
                          'MaxEpochs',10,...                 
                          'ValidationData',{X_val,Y_val_bd},... % show  training error % only with validation set
                          'Verbose',true, ...                % tracking parameters % only with validation set
                          'Shuffle','every-epoch', ...       % only with validation set
                          'InitialLearnRate',1e-2,...        % only with validation set
                          'Plots','training-progress');
bd_cnn = trainNetwork(X_train,Y_train_bd,layers,options);



% testing
testLabel = classify(bd_cnn,X_test);
precision = sum(testLabel==Y_test_bd)/numel(testLabel);
disp(['Testing accuracy',num2str(precision*100),'%'])
