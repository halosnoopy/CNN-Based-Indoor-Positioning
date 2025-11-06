clear
close
clc

load image_data.mat

b = unique(img_label(:,6));
dict = [];
for i = 1:size(b,1)
    a = img_label(img_label(:,6)==b(i),:);
    xy = a(1,1:2);
    fl = a(1,4)+1;
    bd = a(1,5)+1;
    bl = a(1,6)+1;
    t = [xy,fl,bd,bl];
    dict = [dict;t];
end

clearvars -except dict
save dictionary