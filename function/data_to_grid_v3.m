function [nn_features,nn_lables] = get_grided_data(old_lables,features,grid_size)
% old_lables =features;
block_list = get_block_info(old_lables,grid_size);
floornumber = unique(old_lables(:,3));
nn_features = [];
nn_lables = [];

for fn = 1: length(floornumber)
    tem_features = features(old_lables(:,3)==floornumber(fn),:);
    tem_lables = old_lables(old_lables(:,3)==floornumber(fn),:);
    [block_info,to_del] = block_in_building_v2(tem_lables,block_list);
    tem_features(to_del,:)=[];
    tem_lables(to_del,:)=[];
    nn_features = [nn_features;tem_features];
    nn_lables = [nn_lables;[tem_lables,block_info]];
end


