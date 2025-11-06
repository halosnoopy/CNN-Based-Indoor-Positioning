function [new_img,new_label] = grid_to_image(xtem,ytem,image_width,nof,step_size)
% this function will process the grided data to images and return the
% information of the image and the new labels

blocknumber = unique(ytem(:,6));
new_img = [];
new_label = [];
for nb = 1:length(blocknumber)
    tem_x = xtem(ytem(:,6)==blocknumber(nb),:);
    tem_y = ytem(ytem(:,6)==blocknumber(nb),:);
    for i = 1:length(blocknumber)
        [~,ind] = sort(tem_y(:,5));
        xtem_new = tem_x(ind,:);
        img_data = [];
        if size(xtem_new,1) >= image_width
            for j = 1:step_size:size(xtem_new,1)
                start_p = j;
                end_p = j+image_width-1;
                if end_p == size(xtem_new,1)
                    img_data = cat(3,img_data,xtem_new(start_p:end_p,:));
                    break;
                elseif end_p < size(xtem_new,1)
                    img_data = cat(3,img_data,xtem_new(start_p:end_p,:));
                elseif end_p > size(xtem_new,1)
                    img_part1 = xtem_new(start_p:xtem_new,:);
                    to_fill = image_width - size(img_part1,1);
                    img_part2 = xtem_new(1:to_fill,:);
                    img_data = cat(3,img_data,[img_part1;img_part2]);
                    break;
                end
            end
        else
            rows_to_fill = image_width - size(xtem_new,1);
            img_fill = ones(rows_to_fill,size(xtem_new,2)) .*xtem_new(size(xtem_new,1),:);
            img_data = cat(3,img_data,[xtem_new;img_fill]);
        end
        no_of_block = ones(size(img_data,3),1).*nb;
        new_cor = ones(size(img_data,3),2) .* mean(tem_y(:,1:2),1);
        building_no = ones(size(img_data,3),1) .*ytem(1,4);
        no_of_floor = ones(size(img_data,3),1) .*nof;
        img_label = [new_cor,no_of_block,no_of_floor,building_no];
    end

    new_img = cat(3,new_img,img_data);
    new_label = [new_label;img_label];

end
