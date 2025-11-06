clear
clc
close all

addpath pre_trained_models\
addpath data\
addpath function\

load data_cnn.mat
clearvars -except Y_test_b Y_test_f Y_test_bd X_test

Y1 = double(Y_test_b);
Y2 = double(Y_test_f);
Y3 = double(Y_test_bd);
Y_test = [Y1,Y2,Y3];
clearvars -except Y_test X_test
load CNN_b.mat
fprintf('Area prediction model loaded! \n')
pause(0.5)
load CNN_f.mat
display('Floor prediction model loaded!')
pause(0.5)
load CNN_bd.mat
display('Building prediction model loaded!')
pause(0.5)
load dictionary.mat

% building pred
bd_cnn = bd_cnn;
% floor pred
f_cnn = f_cnn;
% block pred
b_cnn = b_cnn;
% dictionary
dict = dict; %x,y,floor,building,block
display('Positioning system prepared!')
pause(0.5)
display('study site loaded')
figure(1);
set(gcf,'position',[733,464,1169,507]);
plot3(dict(dict(:,4)==1,1),dict(dict(:,4)==1,2),dict(dict(:,4)==1,3),'w*')
title("Study site")
hold on
plot3(dict(dict(:,4)==2,1),dict(dict(:,4)==2,2),dict(dict(:,4)==2,3),'w*')
hold on
plot3(dict(dict(:,4)==3,1),dict(dict(:,4)==3,2),dict(dict(:,4)==3,3),'w*')
hold on
grid on
pause(1.5)
for i = 1:5
    rind = randi(size(X_test,4));

    display('--------------------')
    display(['Sample ',num2str(i)])
    display('--------------------')
    fprintf(['Building: ',num2str(Y_test(rind,3)),'\nFloor: ',num2str(Y_test(rind,2)), '\nArea: ',num2str(Y_test(rind,1))])
    fprintf('\n--------------------\n')
%     pause(0.5)
%     ind_t = dict(:,3) == Y_test(i,2) & dict(:,4)== Y_test(i,3) & dict(:,5)==Y_test(i,1);
    ind_t = dict(:,3) == Y_test(rind,2) & dict(:,4)== Y_test(rind,3) & dict(:,5)==Y_test(rind,1);

    % image show
    figure(2);
    sgtitle("detected sequential data");
    set(gcf,'position',[1459,69,408,318]);
    
    
    imgs = imagesc(X_test(:,:,:,rind));
    % testing point plot

    figure(1)
    test_cor = dict(ind_t,1:2);
    p1 = plot3(test_cor(1),test_cor(2),Y_test(rind,2),'r*',MarkerSize=10);
    txt1 = ['Position: (',num2str(test_cor(1)),',',num2str(test_cor(2)),')'];
    t1 = text(test_cor(1)-30,test_cor(2)-10,Y_test(rind,2)-0.3, txt1);
    grid on
    hold on
    pause(1)

    build_pred = classify(bd_cnn,X_test(:,:,rind));
    build_pred = double(build_pred);
    fprintf(['estimated building:',num2str(build_pred),'\n'])
%     pause(0.5)
    floor_list = unique(dict(dict(:,4)==build_pred,3));
    [floor_pred,scores_f] = classify(f_cnn,X_test(:,:,rind));
    floor_pred = double(floor_pred);
    fprintf(['estimated floor:',num2str(floor_pred),'\n'])
%     pause(0.5)
    [block_pred,scores_b] = classify(b_cnn,X_test(:,:,rind));
    block_pred = double(block_pred);
    fprintf(['estimated area:',num2str(block_pred),'\n'])
    display('--------------------')
%     pause(1)
    ind_p = dict(:,3) == floor_pred & dict(:,4)== build_pred & dict(:,5)==block_pred;
    pred_cor = dict(ind_p,1:2);
    % draw block
    s = 30;
    blocks = [pred_cor(1)-s,pred_cor(1)+s,pred_cor(2)-s,pred_cor(2)+s];
    a1 = [blocks(1,1),blocks(1,3),floor_pred];
    a2 = [blocks(1,1),blocks(1,4),floor_pred];
    a3 = [blocks(1,2),blocks(1,4),floor_pred];
    a4 = [blocks(1,2),blocks(1,3),floor_pred];
    a= [a1;a2;a3;a4;a1];
    b1 =plot3(a(:,1),a(:,2),a(:,3),'-g',LineWidth=2);
    txt2 = ['Building:',num2str(build_pred),'; Floor:',num2str(floor_pred),'; Are:',num2str(block_pred)];
    t2 = text(a4(1)-30,a4(2)+10,a4(3)+0.3, txt2);
    pause(1)
    delete(p1)
    delete(b1)
    delete(t1)
    delete(t2)
    delete(imgs)


end
