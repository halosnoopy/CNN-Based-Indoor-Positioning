clear
clc
addpath data\
addpath function\
load data_cnn10.mat

% define layers
layers = [
    % model 1
    imageInputLayer([10 520 1],"Name","imageinput")
    batchNormalizationLayer()
%     convolution2dLayer([2 2],10,"Name","conv","Padding","same")
%     reluLayer("Name","relu")
%     convolution2dLayer([3 3],10,"Name","conv","Padding","same")
%     reluLayer("Name","relu")
    convolution2dLayer([3 3],3,"Name","conv","Padding","same")
    reluLayer("Name","relu")
    maxPooling2dLayer([2 2],"Name","maxpool","Padding","same")
    
    fullyConnectedLayer(32,"Name","fc")
    reluLayer("Name","relu")
    fullyConnectedLayer(32,"Name","fc")
    reluLayer("Name","relu")
%     fullyConnectedLayer(512,"Name","fc")
%     reluLayer("Name","relu")

    fullyConnectedLayer(5,"Name","fc")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];
    % model 2
%     imageInputLayer([10 520 1],"Name","imageinput")
%     batchNormalizationLayer("Name","batchnorm")
%     resize2dLayer("Name","resize-output-size","GeometricTransformMode","half-pixel","Method","nearest","NearestRoundingMode","round","OutputSize",[1 1])
%     fullyConnectedLayer(10*250,"Name","fc_1")
%     reluLayer("Name","relu")
%     fullyConnectedLayer(28,"Name","fc_2")
%     softmaxLayer("Name","softmax")
%     classificationLayer("Name","classoutput")];

% hyperparameters
options = trainingOptions('adam',...                         % or adam、rmsprop,sgdm
                          'MiniBatchSize',100, ...            % only with validation set
                          'MaxEpochs',10,...                 
                          'ValidationData',{X_val,Y_val_f},... % show  training error % only with validation set
                          'Verbose',true, ...                % tracking parameters % only with validation set
                          'Shuffle','every-epoch', ...       % only with validation set
                          'InitialLearnRate',1e-2,...        % only with validation set
                          'Plots','training-progress');
f_cnn = trainNetwork(X_train,Y_train_f,layers,options);



% testing
testLabel = classify(f_cnn,X_test);
precision = sum(testLabel==Y_test_f)/numel(testLabel);
disp(['Testing accuracy',num2str(precision*100),'%'])
