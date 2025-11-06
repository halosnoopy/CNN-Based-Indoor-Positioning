clear 
clc
close all
addpath data\
load rawdata.mat

trainData = trainingData(:,1:520);
trainLable = trainingData(:,521:524);
trainTimestamps = trainingData(:,529);
testData = validationData(:,1:520);
testLable = validationData(:,521:524);
testTimestamps = validationData(:,529);

%% plot the map
figure 
plot3(trainLable(trainLable(:,4)==0,1),trainLable(trainLable(:,4)==0,2),trainLable(trainLable(:,4)==0,3),'r*')
hold on
plot3(trainLable(trainLable(:,4)==1,1),trainLable(trainLable(:,4)==1,2),trainLable(trainLable(:,4)==1,3),'g*')
hold on
plot3(trainLable(trainLable(:,4)==2,1),trainLable(trainLable(:,4)==2,2),trainLable(trainLable(:,4)==2,3),'b*')
title('UJIIndoorLoc Scenario')

figure
plot3(testLable(testLable(:,4)==0,1),testLable(testLable(:,4)==0,2),testLable(testLable(:,4)==0,3),'r*')
hold on
plot3(testLable(testLable(:,4)==1,1),testLable(testLable(:,4)==1,2),testLable(testLable(:,4)==1,3),'g*')
hold on
plot3(testLable(testLable(:,4)==2,1),testLable(testLable(:,4)==2,2),testLable(testLable(:,4)==2,3),'b*')
title('points in testing set')

%% count numumber of points

points = trainLable(1,:);
for i = 1: size(trainData,1)
    repeat_time = 0;
    for j = 1:size(points,1)
        if trainLable(i,1) == points(j,1) &&  trainLable(i,2) == points(j,2) && trainLable(i,3) == points(j,3)
            repeat_time = repeat_time + 1;
        end
    end
    if repeat_time == 0
        points = [points;trainLable(i,:)];
    end

end

points_val = testLable(1,:);
for i = 1: size(testData,1)
    repeat_time = 0;
    for j = 1:size(points_val,1)
        if testLable(i,1) == points_val(j,1) &&  testLable(i,2) == points_val(j,2) && testLable(i,3) == points_val(j,3)
            repeat_time = repeat_time + 1;
        end
    end
    if repeat_time == 0
        points_val = [points_val;testLable(i,:)];
    end

end

display(['number of points in train set: ',num2str(size(points,1))]);
display(['number of points in validation set: ',num2str(size(points_val,1))]);
display('-----------------------------------------------------------------');
%% number of sample in each point

mean_vol_tra = [];
mean_vol_val = [];
for i = 1:size(points,1)
    num=0;
    for j =1:size(trainLable,1)
        if trainLable(j,1) == points(i,1) &&  trainLable(j,2) == points(i,2) && trainLable(j,3) == points(i,3)
            num = num +1;
        end
    end
    mean_vol_tra = [mean_vol_tra;num];
end
display(['average number of points in one position(training set): ',num2str(round(mean(mean_vol_tra)))]);
display(['maximum number of points in one position(training set): ',num2str(max(mean_vol_tra))]);
display(['minimum number of points in one position(training set): ',num2str(min(mean_vol_tra))]);
display('-----------------------------------------------------------------');
for i = 1:size(points_val,1)
    num=0;
    for j =1:size(testLable,1)
        if testLable(j,1) == points_val(i,1) &&  testLable(j,2) == points_val(i,2) && testLable(j,3) == points_val(i,3)
            num = num +1;
        end
    end
    mean_vol_val = [mean_vol_val;num];
end
display(['average number of points in one position(validation set): ',num2str(round(mean(mean_vol_val)))]);
display(['maximum number of points in one position(validation set): ',num2str(max(mean_vol_val))]);
display(['minimum number of points in one position(validation set): ',num2str(min(mean_vol_val))]);
display('-----------------------------------------------------------------');
