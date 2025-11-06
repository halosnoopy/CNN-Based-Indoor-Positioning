clc
clear
close all
load rawdata.mat
addpath data\
addpath function\


trainData = trainingData(:,1:520);
trainLable = trainingData(:,521:524);
trainTimestamps = trainingData(:,529);
trainData(trainData==100) = -100;

testData = validationData(:,1:520);
testLable = validationData(:,521:524);
testTimestamps = validationData(:,529);
testData(testData==100) = -100;
grid_size = 3;
img_width = 10;
step_size = 10;
% 
build_no = unique(trainLable(:,4));
%% build block information
X_new = [];
Y_new = [];
for i =1: length(build_no)
    label = trainLable((trainLable(:,4)==build_no(i)),:);
    features = trainData((trainLable(:,4)==build_no(i)),:);
    ts = trainTimestamps((trainLable(:,4)==build_no(i)),:);
    label = [label,ts]; 
    [new_features,new_lable] = data_to_grid_v3(label,features,grid_size);
    X_new = [X_new;new_features];
    Y_new = [Y_new;new_lable];
end
% X Y floor building timestamp block num

%% convert to images
img_width = 10;
images = [];
img_label = [];
% sizefile = [];
for i =1: length(build_no)
    fl_no = unique(Y_new(Y_new(:,4)==build_no(i),3));
    for j =1: length(fl_no)
        tem_x = X_new((Y_new(:,4)==build_no(i)) & (Y_new(:,3)==fl_no(j)),:);
        tem_y = Y_new((Y_new(:,4)==build_no(i)) & (Y_new(:,3)==fl_no(j)),:);
        nof = fl_no(j);
        [image_data,image_label] = data_to_images_v3(tem_x,tem_y,img_width,nof,step_size);
        images = cat(3,images,image_data);
        img_label = [img_label;image_label];
    end
end

% mean x y block floor build
% clearvars -except img_label images X_new Y_new
% save image_data