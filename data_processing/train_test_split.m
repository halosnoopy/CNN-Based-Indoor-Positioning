clear
clc
addpath data\
addpath function\
load image_data.mat

data = images;
lable_block = img_label(:,6);
lable_floor = img_label(:,4);
lable_building = img_label(:,5);
% mean x y block floor build
X = reshape(data, [10,520,1,length(data)]);  % h*w**c*s, generate 4D array for training the CNN model
Y_b = categorical(lable_block);                       % type of lable - categorical
Y_f = categorical(lable_floor);    
Y_bd = categorical(lable_building);    

% split the data: 0.5 training, 0.3 validation, 0.2 testing 
idx = randperm(length(data));   
num_train = round(0.5*length(X)); 
num_val = round(0.3*length(X));  

X_train = X(:,:,:,idx(1:num_train));
X_val = X(:,:,:,idx(num_train+1:num_train+num_val));
X_test = X(:,:,:,idx(num_train+num_val+1:end)); 

Y_train_b = Y_b(idx(1:num_train),:);
Y_val_b = Y_b(idx(num_train+1:num_train+num_val),:);
Y_test_b = Y_b(idx(num_train+num_val+1:end),:);

Y_train_f = Y_f(idx(1:num_train),:);
Y_val_f = Y_f(idx(num_train+1:num_train+num_val),:);
Y_test_f = Y_f(idx(num_train+num_val+1:end),:);

Y_train_bd = Y_bd(idx(1:num_train),:);
Y_val_bd = Y_bd(idx(num_train+1:num_train+num_val),:);
Y_test_bd = Y_bd(idx(num_train+num_val+1:end),:);

% clearvars -except X_train X_val X_test Y_train_b Y_val_b Y_test_b  Y_train_bd Y_val_bd Y_test_bd Y_train_f Y_val_f Y_test_f
% save data_cnn
