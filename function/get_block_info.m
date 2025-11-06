function [block_dic] = get_block_in_building(ori_lables,grid_size)


left_bound = min(ori_lables(:,1));
right_bound = max(ori_lables(:,1));
top = max(ori_lables(:,2));
botton = min(ori_lables(:,2));
block_dic = [];

if mod((left_bound-right_bound),grid_size) ~= 0

    to_fill_lr = grid_size-mod((left_bound-right_bound),grid_size);
    left_bound = left_bound;
    right_bound = right_bound + to_fill_lr;
end

if mod((top-botton),grid_size)~=0
    to_fill_ub = grid_size-mod((top-botton),grid_size);
    top = top + to_fill_ub;
    botton = botton;

end


x_cor = left_bound:grid_size:right_bound;
y_cor = botton:grid_size:top;

    %% get data in each block
num_block = 0;
for i = 1:length(x_cor)-1
    for j = 1:length(y_cor)-1
        nofs = 0; % number of sample
        for k = 1: size(ori_lables,1)
            if ori_lables(k,1)>=x_cor(i) && ori_lables(k,1)<=x_cor(i+1) && ori_lables(k,2)>=y_cor(j)  && ori_lables(k,2)<=y_cor(j+1)
                nofs = nofs + 1; 
            end
        end

        if nofs>0    
            l = [x_cor(i),x_cor(i+1),y_cor(j),y_cor(j+1),num_block];
            block_dic= [block_dic;l];
            num_block =num_block + 1;
        end

    end
end
    


