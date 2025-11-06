clear
clc
close all

load image_data.mat

% % mean x y block floor build

build_no = unique(img_label(:,5));
grid_size = 3;

new_images = [];
new_label = [];
for i = 1:length(build_no)
    ori_l = Y_new(Y_new(:,4)==build_no(i),:);
    cur_l = img_label(img_label(:,5)==build_no(i),:);
    cur_f = images(:,:,img_label(:,5)==build_no(i));
    block_list = get_block_info(ori_l,grid_size);
    [nn,to_del] = block_in_building_v2(cur_l,block_list);

    if size(to_del,1) > 0
        cur_l(to_del,:) = [];
        cur_f(:,:,to_del) = [];
    end

    new_images = cat(3,new_images,cur_f);
    new_label = [new_label;[cur_l,nn]];
end 
lbi = 0;
build_no = unique(new_label(:,5));
lb = [];
for i = 1:length(build_no)
    block_no = unique(new_label(new_label(:,5)==build_no(i),6));
    for k = 1:length(block_no)
        a = size(new_label(new_label(:,5)==build_no(i) & new_label(:,6)==block_no(k),:),1);
        if a > 0
            b = ones(a,1).*lbi;
            lb = [lb;b];
            lbi = lbi + 1;
        end
    end
end

clearvars -except new_images new_label lb X_new Y_new
images = new_images;
img_label = [new_label(:,1:5),lb];
clearvars -except images img_label X_new Y_new
save data_cnn.mat
