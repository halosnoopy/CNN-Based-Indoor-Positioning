function [new_blockn,del_ind] = get_block_in_building(cur_lables,list)
new_blockn = [];
del_ind = [];
for i = 1:size(cur_lables,1)
    rt = 0;
    for j = 1:size(list,1)
        if cur_lables(i,1)>=list(j,1) && cur_lables(i,1)<=list(j,2) && cur_lables(i,2)>=list(j,3) && cur_lables(i,2)<=list(j,4)
            new_blockn=[new_blockn;list(j,5)];
            break;
        else
            rt = rt+1;
        end
    end
    if rt == size(list,1)
        del_ind=[del_ind;i];
    end
end